#!/usr/bin/env node
/**
 * One-time script to obtain a GBP refresh token via OAuth 2.0.
 *
 * Usage:
 *   1. Set GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET env vars
 *   2. Run: node scripts/get-gbp-token.mjs
 *   3. Open the URL printed in your browser
 *   4. Authorize with the Google account that owns the GBP listing
 *   5. You'll be redirected to localhost — the script captures the code
 *   6. The refresh token is printed to the console
 */

import http from 'node:http'
import { URL } from 'node:url'

const CLIENT_ID = process.env.GOOGLE_CLIENT_ID
const CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET
const REDIRECT_URI = 'http://localhost:3000/oauth/callback'
const SCOPE = 'https://www.googleapis.com/auth/business.manage'

if (!CLIENT_ID || !CLIENT_SECRET) {
  console.error('Missing GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET env vars.')
  console.error('Usage: GOOGLE_CLIENT_ID=xxx GOOGLE_CLIENT_SECRET=yyy node scripts/get-gbp-token.mjs')
  process.exit(1)
}

// Step 1: Build authorization URL
const authUrl = new URL('https://accounts.google.com/o/oauth2/v2/auth')
authUrl.searchParams.set('client_id', CLIENT_ID)
authUrl.searchParams.set('redirect_uri', REDIRECT_URI)
authUrl.searchParams.set('response_type', 'code')
authUrl.searchParams.set('scope', SCOPE)
authUrl.searchParams.set('access_type', 'offline')
authUrl.searchParams.set('prompt', 'consent') // Force refresh token

console.log('\n=== Google Business Profile OAuth ===\n')
console.log('Open this URL in your browser:\n')
console.log(authUrl.toString())
console.log('\nWaiting for callback on http://localhost:3000 ...\n')

// Step 2: Start local server to capture the redirect
const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, 'http://localhost:3000')

  if (url.pathname !== '/oauth/callback') {
    res.writeHead(404)
    res.end('Not found')
    return
  }

  const code = url.searchParams.get('code')
  const error = url.searchParams.get('error')

  if (error) {
    res.writeHead(400, { 'Content-Type': 'text/html; charset=utf-8' })
    res.end(`<h1>Erreur : ${error}</h1>`)
    console.error('OAuth error:', error)
    server.close()
    process.exit(1)
  }

  if (!code) {
    res.writeHead(400, { 'Content-Type': 'text/html; charset=utf-8' })
    res.end('<h1>Pas de code reçu</h1>')
    return
  }

  // Step 3: Exchange code for tokens
  try {
    const tokenRes = await fetch('https://oauth2.googleapis.com/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        code,
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        redirect_uri: REDIRECT_URI,
        grant_type: 'authorization_code',
      }),
    })

    const tokens = await tokenRes.json()

    if (tokens.error) {
      throw new Error(`${tokens.error}: ${tokens.error_description}`)
    }

    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' })
    res.end('<h1>OK ! Retourne dans le terminal pour copier le refresh token.</h1>')

    console.log('=== TOKENS ===\n')
    console.log('GBP_REFRESH_TOKEN=' + tokens.refresh_token)
    console.log('\n(Access token, pour test immédiat : ' + tokens.access_token + ')\n')

    // Step 4: List accounts and locations with the access token
    console.log('=== Récupération de tes établissements GBP ===\n')

    const accountsRes = await fetch(
      'https://mybusinessbusinessinformation.googleapis.com/v1/accounts',
      { headers: { Authorization: `Bearer ${tokens.access_token}` } }
    )

    // Try the Account Management API instead
    const acctRes = await fetch(
      'https://mybusinessaccountmanagement.googleapis.com/v1/accounts',
      { headers: { Authorization: `Bearer ${tokens.access_token}` } }
    )
    const acctData = await acctRes.json()

    if (acctData.accounts && acctData.accounts.length > 0) {
      for (const account of acctData.accounts) {
        console.log(`Account: ${account.name} (${account.accountName})`)

        // List locations for this account
        const locRes = await fetch(
          `https://mybusinessbusinessinformation.googleapis.com/v1/${account.name}/locations?readMask=name,title,storefrontAddress`,
          { headers: { Authorization: `Bearer ${tokens.access_token}` } }
        )
        const locData = await locRes.json()

        if (locData.locations && locData.locations.length > 0) {
          for (const loc of locData.locations) {
            console.log(`  Location: ${loc.name}`)
            console.log(`    Title: ${loc.title}`)
            if (loc.storefrontAddress) {
              console.log(`    Address: ${loc.storefrontAddress.addressLines?.join(', ')}`)
            }
            console.log('')
          }
          console.log('→ Copie le "name" de ton établissement comme GBP_LOCATION_NAME')
        } else {
          console.log('  Aucune location trouvée pour ce compte.')
          console.log('  locData:', JSON.stringify(locData, null, 2))
        }
      }
    } else {
      console.log('Aucun compte GBP trouvé.')
      console.log('Response:', JSON.stringify(acctData, null, 2))
    }
  } catch (err) {
    res.writeHead(500, { 'Content-Type': 'text/html; charset=utf-8' })
    res.end(`<h1>Erreur : ${err.message}</h1>`)
    console.error('Error:', err)
  }

  server.close()
})

server.listen(3000)
