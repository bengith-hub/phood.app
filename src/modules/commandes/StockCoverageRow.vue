<script setup lang="ts">
export interface StockCoverageInfo {
  stockActuel: number
  stockTampon: number
  previsionConso3j: number
  recommandationQty: number
  dateCouverture: string | null
  rotationJours: number | null
  rotationLabel: string
  rotationIcon: string
  coverageOk: boolean
  unite: string
  noRecentData?: boolean
  enTransit?: number
}

const props = defineProps<{
  coverage: StockCoverageInfo | null
}>()
</script>

<template>
  <div v-if="props.coverage" class="stock-coverage">
    <!-- Alert: no recent stock data -->
    <div v-if="props.coverage.noRecentData" class="stock-alert">
      Pas de donn&eacute;es stock r&eacute;centes (&gt;30j)
    </div>

    <div class="stock-row">
      <div class="stock-item">
        <span class="stock-label">Stock actuel</span>
        <span class="stock-value">{{ props.coverage.stockActuel.toFixed(1) }} {{ props.coverage.unite }}</span>
      </div>
      <div v-if="props.coverage.enTransit && props.coverage.enTransit > 0" class="stock-item">
        <span class="stock-label">En transit</span>
        <span class="stock-value transit">+{{ props.coverage.enTransit.toFixed(1) }} {{ props.coverage.unite }}</span>
      </div>
      <div class="stock-item">
        <span class="stock-label">Tampon</span>
        <span class="stock-value">{{ props.coverage.stockTampon.toFixed(1) }} {{ props.coverage.unite }}</span>
      </div>
      <div class="stock-item">
        <span class="stock-label">Conso 3j</span>
        <span class="stock-value">{{ props.coverage.previsionConso3j.toFixed(1) }} {{ props.coverage.unite }}</span>
      </div>
      <div class="stock-item">
        <span class="stock-label">Recommand&eacute;</span>
        <span class="stock-value reco">{{ props.coverage.recommandationQty }}</span>
      </div>
    </div>
    <div class="stock-row second">
      <div v-if="props.coverage.dateCouverture" class="stock-item">
        <span class="stock-label">Couverture jusqu'au</span>
        <span
          class="stock-value coverage-date"
          :class="{
            'coverage-ok': props.coverage.coverageOk,
            'coverage-warn': !props.coverage.coverageOk,
          }"
        >
          {{ props.coverage.dateCouverture }}
        </span>
      </div>
      <div v-if="props.coverage.rotationLabel" class="stock-item">
        <span class="stock-label">Rotation</span>
        <span class="stock-value rotation">
          {{ props.coverage.rotationIcon }} {{ props.coverage.rotationLabel }}
          <span v-if="props.coverage.rotationJours" class="rotation-days">
            ({{ Math.round(props.coverage.rotationJours) }}j)
          </span>
        </span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.stock-coverage {
  padding: 8px 16px 12px;
  border-top: 1px solid var(--border);
  background: var(--bg-main);
}

.stock-alert {
  padding: 6px 10px;
  margin-bottom: 8px;
  font-size: 13px;
  font-weight: 600;
  color: #92400e;
  background: #fef3cd;
  border-radius: 6px;
}

.stock-row {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.stock-row.second {
  margin-top: 8px;
}

.stock-item {
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 100px;
}

.stock-label {
  font-size: 11px;
  font-weight: 600;
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.3px;
}

.stock-value {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}

.stock-value.reco {
  color: var(--color-primary);
}

.stock-value.transit {
  color: var(--color-info, #2563eb);
}

.coverage-date.coverage-ok {
  color: var(--color-success);
}

.coverage-date.coverage-warn {
  color: var(--color-warning);
}

.rotation {
  display: flex;
  align-items: center;
  gap: 4px;
}

.rotation-days {
  font-size: 12px;
  color: var(--text-tertiary);
  font-weight: 400;
}
</style>
