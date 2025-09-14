<template>
  <div class="h-full min-h-screen bg-background_gray pb-4">
    <h1 class="pt-20 pb-10 px-4 md:px-20 font-poppins font-semibold text-3xl md:text-5xl text-white">Olá, <span class="text-orange">{{
      studentInfo.name.split(' ')[0] }}!</span></h1>
    <div class="mx-4 md:mx-20 p-4 md:p-6 border border-[#69655F] rounded-xl relative mb-4">
      <div class="flex items-center justify-between mb-4 md:mb-8">
        <div class="flex justify-start items-center">
          <SquareUserRound :stroke-width="1.0" class="w-6 h-6 md:w-10 md:h-10 text-white" />
          <h2 class="pl-2 font-semibold text-white text-xl md:text-3xl justify-start">Informação Pessoal</h2>
        </div>
        <div class="flex justify-end items-center">
          <button @click="toggleEdit" aria-label="Edit">
            <SquarePen :stroke-width="1.25" class="w-6 h-6 md:w-9 md:h-9" :class="isEditing ? 'text-white' : 'text-orange'" />
          </button>
        </div>
      </div>

      <div class="pb-3 md:pb-5 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-12 ml-0 md:ml-12 font-semibold text-base md:text-xl">
        <div>
          <h3 class="text-white font-poppins">Nome Completo</h3>
          <input v-if="isEditing" v-model="studentInfo.name"
            class="w-full bg-[#403D39] text-[#CCC5B9] font-light px-2 text-base mt-2 p-1 rounded" />
          <p v-else class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.name }}</p>
        </div>
        <div>
          <h3 class="text-white font-poppins">Nº de Aluno</h3>
          <p class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.studentNumber }}</p>
        </div>
        <div>
          <h3 class="text-white font-poppins">Estatuto</h3>
          <p class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.status }}</p>
        </div>
      </div>

      <div class="pb-3 md:pb-5 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 lg:gap-20 md:gap-12 xl:gap-12 mb-4 ml-0 md:ml-12 text-base md:text-xl font-semibold">
        <div>
          <h3 class="text-white font-poppins">Endereço de Email</h3>
          <p class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.email }}</p>
        </div>
        <div>
          <h3 class="text-white font-poppins">Nº Telemóvel</h3>
          <input v-if="isEditing" v-model="studentInfo.phone"
            class="w-full bg-[#403D39] text-[#CCC5B9] font-light px-2 text-base mt-2 p-1 rounded" />
          <p v-else class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.phone }}</p>
        </div>
      </div>

      <div class="pb-3 md:pb-5 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-12 mb-4 ml-0 md:ml-12 text-base md:text-xl font-semibold">
        <div>
          <h3 class="text-white font-poppins">Curso</h3>
          <p class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.course }}</p>
        </div>
        <div>
          <h3 class="text-white font-poppins">Nível</h3>
          <p class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.level }}</p>
        </div>
        <div>
          <h3 class="text-white font-poppins">Ano</h3>
          <p class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.year }}</p>
        </div>
      </div>

      <div class="pb-3 md:pb-5 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-12 mb-0 md:mb-4 ml-0 md:ml-12 text-base md:text-xl font-semibold">
        <div>
          <h3 class="text-white font-poppins">Média Geral</h3>
          <p class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.average }}</p>
        </div>
        <div>
          <h3 class="text-white font-poppins">ECTS</h3>
          <p class="font-poppins text-[#CCC5B9] underline font-light">{{ studentInfo.credits }}</p>
        </div>
      </div>

      <div v-if="isEditing" class="flex flex-col sm:flex-row justify-end space-y-2 sm:space-y-0 sm:space-x-4">
        <button @click="discardChanges" aria-label="Cancelar"
          class="w-full sm:w-auto px-6 sm:px-12 py-1 border border-orange text-white font-semibold text-lg md:text-2xl hover:bg-orange hover:scale-105 transition-all rounded-3xl">
          Cancelar
        </button>
        <button @click="saveChanges" aria-label="Guardar Alterações" class="w-full sm:w-auto px-6 py-1 bg-orange font-semibold text-lg md:text-2xl text-white rounded-3xl hover:bg-orange/80 hover:scale-105 transition-all">
          Guardar Alterações
        </button>
      </div>
    </div>

    <div class="hidden lg:block absolute bottom-5 right-0 left-0 md:left-72 text-white text-sm text-center px-4">
      <p class="text-center">
        Feito por: João Sá <span class="text-orange">/</span> João Cunha <span class="text-orange">/</span> Francisco
        Castro <span class="text-orange">/</span> Gonçalo Alves <span class="text-orange">/</span> Rodrigo Ferreira
      </p>
    </div>
    
  </div>
  <SuccessToast v-if="showSuccessToast" />
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { SquareUserRound, SquarePen } from 'lucide-vue-next'
import axios from 'axios'
import SuccessToast from '../components/SuccessToast.vue'
import { useRoute, useRouter } from 'vue-router';


const showSuccessToast = ref(false);
const route = useRoute();
const router = useRouter();

const isEditing = ref(false)
const studentInfo = ref({
  name: '',
  studentNumber: '',
  status: '',
  email: '',
  phone: '',
  course: '',
  level: '',
  year: '',
  average: '',
  credits: ''
})

function toggleEdit() {
  isEditing.value = !isEditing.value
}

async function saveChanges() {
  try {
    const authStore = useAuthStore()
    const studentId = authStore.user.id

    await axios.patch(`http://localhost:3000/students/${studentId}`, {
      name: studentInfo.value.name,
      phone: studentInfo.value.phone,
    });

    await profileDetails();
    isEditing.value = false;
  } catch (error) {
    console.error('Error saving changes:', error);
  }
}

async function profileDetails() {
  try {
    const authStore = useAuthStore()
    const studentId = authStore.user.id
    const response = await axios.get(`http://localhost:3000/students/${studentId}`)
    const data = response.data
    const email = response.data.email.split('@')[0].toUpperCase()

    studentInfo.value = {
      name: data.name,
      studentNumber: email,
      status: data.specialStatus,
      email: data.email,
      phone: data.phone,
      course: 'Engenharia Informática',
      level: 'Licenciatura',
      year: data.year,
      average: data.mean,
      credits: data.credits
    }

  } catch (error) {
    console.error('Error fetching student info:', error)
  }
}

function discardChanges() {
  isEditing.value = false
  profileDetails()
}

// Esta função será chamada automaticamente quando o componente for montado
onMounted(() => {
  profileDetails();


  if (route.query.showSuccessToast === 'true') {
    showSuccessToast.value = true;
    setTimeout(() => {
      showSuccessToast.value = false;
      // Remove the query parameter using router
      router.replace({ query: {} });  // Correct way to remove query params
    }, 5000);
  }
});
</script>