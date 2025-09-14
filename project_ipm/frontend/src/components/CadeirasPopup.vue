<template>
  <div v-if="show"
    class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-2 overflow-y-auto animate-fade-in">
    <div
      class="bg-[#252422] rounded-2xl p-4 sm:p-8 max-w-[90vw] sm:max-w-4xl w-full relative max-h-[90vh] overflow-y-auto">
      <button @click="$emit('close')" class="absolute top-2 right-2 sm:top-4 sm:right-4 text-orange-400 text-xl">
        <X class="w-6 h-6 sm:w-8 sm:h-8 text-orange" />
      </button>
      <h2 class="text-white text-xl pt-6 md:pt-0 sm:text-3xl font-semibold text-center mb-6 sm:mb-8">
        Unidades Curriculares do {{ ano }}º Ano
      </h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 sm:gap-6">
        <button v-for="(cadeira, index) in cadeiras" :key="index"
          @click="$router.push(`/directors/consultar-turnos/${cadeira.id}`)"
          class="border border-orange text-white font-bold px-4 py-3 rounded-lg
                hover:bg-orange hover:bg-opacity-60 hover:border-opacity-10 transition
                  w-full min-h-[80px] flex items-center justify-center text-center whitespace-normal text-sm sm:text-base">
          {{ cadeira.name }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { X } from 'lucide-vue-next';
export default {
  name: "CadeirasPopup",
  props: {
    ano: Number,
    cadeiras: Array,
    show: Boolean
  },
  components: {
    X
  }
};
</script>

<style scoped>
/* Fade-in Animation */
@keyframes fade-in {
  from {
    opacity: 0;
    transform: scale(0.97);
  }

  to {
    opacity: 1;
    transform: scale(1);
  }
}

.animate-fade-in {
  animation: fade-in 0.25s ease-out;
}
</style>