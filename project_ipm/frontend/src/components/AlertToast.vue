<template>
    <div v-if="visible"
        class="fixed top-6 right-4 sm:top-10 sm:right-10 z-50 flex items-center p-3 sm:p-4 w-[90%] sm:max-w-sm text-white bg-gray-800 rounded-lg shadow-md overflow-hidden"
        :class="{ 'backdrop-blur-md': isMobile }" :style="toastStyle">
        <div class="flex-shrink-0 relative">
            <div class="w-10 h-10 flex items-center justify-center rounded-full bg-yellow-500 relative">
                <div class="absolute inset-0 rounded-full border-8 border-gray-800 opacity-60"></div>
                <svg class="w-5 h-5 text-white z-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
            </div>
        </div>
        <div class="ml-3 sm:ml-4">
            <p class="font-bold text-white text-sm sm:text-base">A alteração não foi efetuada</p>
            <p class="text-xs sm:text-sm text-gray-300">Não realizou alterações aos dados já existentes</p>
        </div>

        <div class="absolute bottom-0 left-0 h-1 bg-yellow-500 transition-all" :style="{ width: progressWidth + '%' }">
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'

const visible = ref(true)
const progressWidth = ref(100)
const isMobile = computed(() => window.innerWidth < 640)

const toastStyle = computed(() => {
    return {
        background: isMobile.value
            ? 'linear-gradient(to right, rgba(255, 235, 59, 0.6), #1f2937 100%)'
            : 'linear-gradient(to right, rgba(255, 235, 59, 0.18), #1f2937 100%)'
    }
})

onMounted(() => {
    const duration = 5000
    const startTime = Date.now()

    const update = () => {
        const elapsed = Date.now() - startTime
        const percentage = Math.max(100 - (elapsed / duration) * 100, 0)
        progressWidth.value = percentage

        if (percentage > 0) {
            requestAnimationFrame(update)
        } else {
            visible.value = false
        }
    }

    requestAnimationFrame(update)
})
</script>

<style scoped>
.transition-all {
    transition: width 0.1s linear;
}
</style>