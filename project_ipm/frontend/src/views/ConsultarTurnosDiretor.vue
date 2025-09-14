<template>
  <div class="h-screen bg-background_gray flex flex-col font-poppins overflow-x-hidden">
    <h1 class="px-20 xl:px-8 py-8 md:py-7 xl:py-10 pb-16 text-sm md:text-lg font-semibold text-white">
      <span class="text-white/50">Gestão de Turnos /</span> Consultar Turnos
    </h1>

    <div class="px-8 pt-0 md:pt-10 xl:pt-2">
      <p class="text-white text-sm md:text-base text-center">
        <span class="text-orange">Selecione</span> um <span class="text-orange">ANO</span> e uma
        <span class="text-orange">UC</span> para consultar os horários dos seus turnos.
      </p>
    </div>

    <div class="px-8 pt-12 flex flex-col gap-6 items-center justify-center">
      <div
        class="group relative w-full max-w-[1200px] mx-auto h-24 xl:h-36 rounded-2xl xl:rounded-3xl bg-[#121212] border-4 border-[#121212] hover:border-orange transition-all duration-300 cursor-pointer flex items-center justify-center shadow-lg shadow-black/20 overflow-hidden"
        @click="abrirModal(1)">
        <div
          class="absolute -bottom-44 right-0 w-[410px] h-[420px] transition-transform duration-500 ease-in-out translate-x-full group-hover:translate-x-0">
          <svg viewBox="0 0 838 422" xmlns="http://www.w3.org/2000/svg" class="w-full h-full">
            <path
              d="M833 252.5C833 347.217 347.263 421.5 241.5 421.5C135.738 421.5 0 412.217 0 317.5C0 222.783 514 306 703.5 0C873.5 25 833 157.783 833 252.5Z"
              fill="#EB5E28" transform="translate(80, 0)" />
          </svg>
        </div>

        <p
          class="relative text-2xl xl:text-4xl font-semibold text-white group-hover:text-orange transition-colors duration-300">
          1º ANO
        </p>
      </div>

      <div
        class="group relative w-full max-w-[1200px] mx-auto h-24 xl:h-36 rounded-2xl xl:rounded-3xl bg-[#121212] border-4 border-[#121212] hover:border-orange transition-all duration-300 cursor-pointer flex items-center justify-center shadow-lg shadow-black/20 overflow-hidden"
        @click="abrirModal(2)">
        <div
          class="absolute -bottom-44 right-0 w-[410px] h-[420px] transition-transform duration-500 ease-in-out translate-x-full group-hover:translate-x-0">
          <svg viewBox="0 0 838 422" xmlns="http://www.w3.org/2000/svg" class="w-full h-full">
            <path
              d="M833 252.5C833 347.217 347.263 421.5 241.5 421.5C135.738 421.5 0 412.217 0 317.5C0 222.783 514 306 703.5 0C873.5 25 833 157.783 833 252.5Z"
              fill="#EB5E28" transform="translate(80, 0)" />
          </svg>
        </div>
        <p
          class="relative text-2xl xl:text-4xl font-semibold text-white group-hover:text-orange transition-colors duration-300">
          2º ANO
        </p>
      </div>

      <div
        class="group relative w-full max-w-[1200px] mx-auto h-24 xl:h-36 rounded-2xl xl:rounded-3xl bg-[#121212] border-4 border-[#121212] hover:border-orange transition-all duration-300 cursor-pointer flex items-center justify-center shadow-lg shadow-black/20 overflow-hidden"
        @click="abrirModal(3)">
        <div
          class="absolute -bottom-44 right-0 w-[410px] h-[420px] transition-transform duration-500 ease-in-out translate-x-full group-hover:translate-x-0">
          <svg viewBox="0 0 838 422" xmlns="http://www.w3.org/2000/svg" class="w-full h-full">
            <path
              d="M833 252.5C833 347.217 347.263 421.5 241.5 421.5C135.738 421.5 0 412.217 0 317.5C0 222.783 514 306 703.5 0C873.5 25 833 157.783 833 252.5Z"
              fill="#EB5E28" transform="translate(80, 0)" />
          </svg>
        </div>
        <p
          class="relative text-2xl xl:text-4xl font-semibold text-white group-hover:text-orange transition-colors duration-300">
          3º ANO
        </p>
      </div>
    </div>

    <div class="absolute bottom-10 right-5 left-72 text-white text-sm hidden xl:block">
      <p class="text-center">
        Feito por: João Sá <span class="text-orange">/</span> João Cunha
        <span class="text-orange">/</span> Francisco Castro <span class="text-orange">/</span> Gonçalo Alves
        <span class="text-orange">/</span> Rodrigo Ferreira
      </p>
    </div>

    <CadeirasPopup :show="mostrarPopup" :ano="anoSelecionado" :cadeiras="cadeirasPorAno[anoSelecionado]"
      @close="mostrarPopup = false" />
  </div>
</template>

<script>
import CadeirasPopup from '@/components/CadeirasPopup.vue'
import axios from 'axios'
import { ref, onMounted } from 'vue'

export default {
  name: 'ConsultarTurnosDiretor',
  components: {
    CadeirasPopup
  },
  setup() {
    const mostrarPopup = ref(false)
    const anoSelecionado = ref(null)
    const cadeirasPorAno = ref({})

    const abrirModal = (ano) => {
      anoSelecionado.value = ano
      mostrarPopup.value = true
    }

    const fetchCadeiras = async () => {
      try {
        const response = await axios.get('http://localhost:3000/courses')
        const cadeiras = response.data
        const cadeirasOrganizadas = {}
        cadeiras.forEach(cadeira => {
          const ano = cadeira.year
          if (!cadeirasOrganizadas[ano]) {
            cadeirasOrganizadas[ano] = []
          }
          cadeirasOrganizadas[ano].push(cadeira)
        })

        cadeirasPorAno.value = cadeirasOrganizadas
      } catch (error) {
        console.error('Erro ao buscar cadeiras:', error)
      }
    }

    onMounted(() => {
      fetchCadeiras()
    })

    return {
      mostrarPopup,
      anoSelecionado,
      cadeirasPorAno,
      abrirModal
    }
  }
}
</script>