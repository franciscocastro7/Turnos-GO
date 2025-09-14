<template>
  <div v-if="conflicts" class="min-h-screen flex flex-col justify-center items-center bg-background_gray">
    <h1 class="text-white text-lg sm:text-xl md:text-2xl font-poppins font-semibold text-center">O teu horário ainda não foi publicado, ainda não podes requisitar trocas de turno</h1>
    <div class="flex justify-center items-center text-[#D9D9D9]">
      <a href="/students/home" class="underline text-lg decoration-orange">Voltar</a>
    </div>
  </div>
  <div v-else class="min-h-screen bg-background_gray">
    <h1 class="px-20 xl:px-8 py-8 md:py-7 xl:py-10 pb-16 text-sm md:text-lg font-poppins font-semibold text-white">
      <span class="font-poppins text-white/50">Gestão de Turnos /</span>
      Requisitar Troca
    </h1>
    <div class="mx-6 md:mx-20 rounded-xl">
      <div class="bg-background_gray text-white w-full flex flex-col md:flex-row md:space-x-16">
        <div class="w-full md:w-1/2">
          <h2 class="text-2xl font-bold border-gray-700 pb-2 mt-8 font-poppins">Unidade Curricular</h2>
          <select @change="getCourseInfo" v-model="formData.subject" aria-label="Subject"
            class="w-full p-2 bg-background_gray border-2 border-white-500 rounded text-white font-poppins font-semibold">
            <option v-for="course in courses" :key="course.id" :value="course">{{ course.name }}</option>
          </select>

          <h2 class="text-2xl font-bold border-gray-700 pb-2 mt-8 font-poppins">Turno Atual</h2>
          <select @change="getCurrentShiftTeacher; getAvailableDesiredShifts()" v-model="formData.currentShift" aria-label="Turno Atual"
            class="w-full p-2 bg-background_gray border-2 border-white-500 rounded text-white font-poppins font-semibold">
            <option v-for="shift in studentAllocatedShifts" :key="shift.id" :value="shift">
              {{ shift.name }} ({{ getDay(shift.day) }} {{ shift.from }}h00 - {{ shift.to }}h00)
            </option>
          </select>

          <h2 class="text-2xl font-bold border-gray-700 pb-2 mt-8 font-poppins">Turno Desejado</h2>
          <select
            @change="getDesiredShiftTeacher(); checkScheduleConflict()"
            @blur="checkScheduleConflict()"
            v-model="formData.desiredShift"
            aria-label="Turno Desejado"
            :class="[
              'w-full p-2 bg-background_gray border-2 rounded text-white font-poppins font-semibold',
              hasScheduleConflict ? 'border-red-500' : 'border-white-500'
            ]"
          >
            <option v-if="availableDesiredShifts.length <= 0" value="" disabled selected>Não existem turnos disponíveis</option>
            <option v-for="shift in availableDesiredShifts" :key="shift.id" :value="shift">
              {{ shift.name }} ({{ getDay(shift.day) }} {{ shift.from }}h00 - {{ shift.to }}h00)
            </option>
          </select>
          <p v-if="hasScheduleConflict" class="text-red-500 mt-2 font-poppins text-sm">
            ⚠ Vai causar conflitos de horário!
          </p>
        </div>

        <div class="w-full md:w-1/2 mt-8 md:mt-6">
          <h2 class="text-2xl font-bold border-gray-700 pb-2 font-poppins">Motivo da Troca</h2>
          <textarea v-model="formData.reason" aria-label="Motivo da Troca"
            class="w-full h-72 p-2 bg-background_gray border-2 border-white-500 rounded text-white font-poppins font-semibold overflow-y-auto"
            placeholder="Escreve um breve parágrafo indicando o motivo da troca desejada...">
          </textarea>
        </div>
      </div>

      <h2 class="text-2xl font-bold border-gray-700 pb-2 mt-8 font-poppins text-white">Outras Informações (não editável)
      </h2>
      <div
        class="bg-background_gray px-4 py-2 text-white border-2 border-white-500 rounded text-lg font-poppins font-semibold min-h-40">
        <p>Nº Turnos Teóricos: {{ courseInfo.theoreticalShifts }}</p>
        <p>Nº Turnos Práticos: {{ courseInfo.practicalShifts }}</p>
        <p>Créditos da UC: {{ courseInfo.credits }}</p>
        <p>Informação do Docente do Turno Atual: {{ courseInfo.currentProfessor }}</p>
        <p>Informação do Docente do Turno Selecionado: {{ courseInfo.selectedProfessor }}</p>
      </div>

      <div class="flex flex-col xl:flex-row justify-between items-center mt-8 gap-4">
        <div
          class="w-full xl:w-3/6 font-poppins flex space-x-3 border border-orange rounded-lg p-2 text-sm text-white bg-opacity-10 items-center">
          <span class="text-3xl text-center">⚠</span>
          <p class="text-base text-justify">
            Ao efetuar o pedido, este será analisado pela direção do curso pelo que o mesmo poderá não ser aprovado.

            Tempo estimado de resposta: <span class="underline decoration-amber-600">2 dias úteis</span>.
          </p>
        </div>

        <div
          class="flex flex-row space-x-3 w-full xl:w-auto justify-center pb-4 md:pb-0">
          <button @click="router.push({ name: 'inicio-aluno' })"
            class="font-poppins font-bold w-full xl:w-auto px-4 md:px-8 py-3 xl:py-2 border border-orange text-white text-sm xl:text-xl rounded-3xl hover:bg-orange hover:scale-105 transition-all">
            Cancelar
          </button>
          <button @click="showPopup = true"
            class="font-poppins font-bold w-full xl:w-auto px-4 md:px-8 xl:px-12 py-3 xl:py-2 text-sm xl:text-xl text-white rounded-3xl bg-orange hover:scale-105 transition-all hover:bg-orange/80">
            Ver Horário
          </button>
          <button 
            @click="submitRequest" 
            :class="[
              'font-poppins font-bold w-full xl:w-auto px-4 md:px-8 xl:px-12 py-3 xl:py-2 text-sm xl:text-xl text-white rounded-3xl transition-all',
              isFormComplete && !hasScheduleConflict ? 'bg-orange hover:bg-orange/80 hover:scale-105 transition-all' : 'bg-[#403D39] cursor-default'
            ]">
            Efetuar Pedido
          </button>
        </div>
      </div>
    </div>
  </div>
  <ErrorToast v-if="showErrorToast" />
  <div v-if="showPopup"
    class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-2 overflow-y-auto animate-fade-in">
    <div
      class="bg-[#252422] rounded-2xl p-4 sm:p-8 max-w-[90vw] sm:max-w-5xl w-full relative max-h-[90vh] overflow-y-auto">
      <button @click="showPopup = false" class="absolute top-2 right-2 text-white font-bold text-xl">X</button>
      <div class="text-white font-poppins text-lg">
        <SchedulePopup v-if="formData.desiredShift" :show="showPopup" :desired-shift="formData.desiredShift"
          @close="showPopup = false" />
        <SchedulePopup v-else :show="showPopup" @close="showPopup = false" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import { useAuthStore } from '@/stores/auth';
import axios from 'axios';
import { useRouter } from 'vue-router';
import ErrorToast from '@/components/ErrorToast.vue';
import SchedulePopup from '@/components/HorarioPopup.vue';

const showErrorToast = ref(false);
const showPopup = ref(false);
const router = useRouter();

const formData = ref({
  subject: null,
  currentShift: null,
  desiredShift: null,
  reason: ''
});

const availableShifts = ref([]);
const availableDesiredShifts = ref([]);
const studentAllocatedShifts = ref([]);
const courses = ref([]);
const conflicts = ref(true);

const courseInfo = ref({
  theoreticalShifts: '',
  practicalShifts: '',
  credits: '',
  currentProfessor: '',
  selectedProfessor: ''
});

const hasScheduleConflict = ref(false);

const authStore = useAuthStore();
const user = authStore.user;

const isFormComplete = computed(() => {
  return formData.value.subject && 
        formData.value.currentShift && 
        formData.value.desiredShift &&
        formData.value.reason.trim() !== '';
});

// Verifica se o estudante já tem horário publicado
async function getConflicts() {
    try {
        const response = await axios.get(`http://localhost:3000/conflicts?studentId=${user.id}`);
        const allocations = response.data;

        if(allocations.length > 0) {
            conflicts.value = true;
        } else {
            conflicts.value = false;
        }
    } catch (error) {
        console.error('Error fetching conflicts:', error);
    }
}

// Obtém a lista de unidades curriculares do estudante
async function getCourses() {
  try {
    const response = await axios.get(`http://localhost:3000/students/${user.id}`);
    const data = response.data;

    if (response.status === 200) {
      const courseIds = data.enrolled;

      for (const courseId of courseIds) {
        const courseResponse = await axios.get(`http://localhost:3000/courses/${courseId}`);
        const courseData = courseResponse.data;
        courses.value.push(courseData);
      }
    }
  } catch (error) {
    console.error('Error fetching courses:', error);
  }
}

// Obtém informações da UC selecionada e os turnos alocados ao estudante para essa UC
async function getCourseInfo() {
  if (formData.value.subject) {
      // Reset shifts when changing subject
      formData.value.currentShift = null;
      formData.value.desiredShift = null;
      hasScheduleConflict.value = false;
      availableDesiredShifts.value = [];
    try {
      const shiftsResponse = await axios.get(`http://localhost:3000/shifts?courseId=${formData.value.subject.id}`);
      availableShifts.value = shiftsResponse.data;

      const theoreticalShifts = availableShifts.value.filter(shift => shift.type === 'T').length;
      const practicalShifts = availableShifts.value.filter(shift => shift.type === 'PL').length;
      const credits = formData.value.subject.credits;

      courseInfo.value = {
        theoreticalShifts: theoreticalShifts,
        practicalShifts: practicalShifts,
        credits: credits,
        currentProfessor: '',
        selectedProfessor: ''
      };
      
      // Obtém alocações do estudante para esta UC
      await getStudentAllocatedShifts();
    } catch (error) {
      console.error('Error fetching course info:', error);
    }
  }
}

async function getStudentAllocatedShifts() {
  if (!formData.value.subject) return;
  
  try {
    // Obtém todas as alocações do estudante
    const allocationsResponse = await axios.get(`http://localhost:3000/allocations?studentId=${user.id}`);
    const allAllocations = allocationsResponse.data;
    
    // Filtra apenas os turnos da UC selecionada
    studentAllocatedShifts.value = [];
    
    for (const allocation of allAllocations) {
      // Obtém informação do turno
      const shiftResponse = await axios.get(`http://localhost:3000/shifts/${allocation.shiftId}`);
      const shift = shiftResponse.data;

      // Verifica se o turno pertence à UC selecionada
      if (parseInt(shift.courseId) === parseInt(formData.value.subject.id)) {
        studentAllocatedShifts.value.push(shift);
      }
    }
  } catch (error) {
    console.error('Error fetching student allocated shifts:', error);
  }
}

// Obtém os turnos disponíveis para troca (do mesmo tipo que o turno atual)
function getAvailableDesiredShifts() {
  if (!formData.value.currentShift) return;
  
  // Filtra turnos do mesmo tipo (T ou PL) que o turno atual
  const currentShiftType = formData.value.currentShift.type;
  availableDesiredShifts.value = availableShifts.value.filter(shift => 
    shift.type === currentShiftType && 
    shift.id !== formData.value.currentShift.id
  );
  
  // Reset do turno desejado
  formData.value.desiredShift = null;
  hasScheduleConflict.value = false;
}

// Obtém informação do professor do turno atual
async function getCurrentShiftTeacher() {
  if (formData.value.currentShift) {
    try {
      const teacherResponse = await axios.get(`http://localhost:3000/teachers/${formData.value.currentShift.teacherId}`);
      courseInfo.value.currentProfessor = teacherResponse.data.name;
    } catch (error) {
      console.error('Error fetching current shift teacher:', error);
    }
  }
}

// Obtém informação do professor do turno desejado
async function getDesiredShiftTeacher() {
  if (formData.value.desiredShift) {
    try {
      const teacherResponse = await axios.get(`http://localhost:3000/teachers/${formData.value.desiredShift.teacherId}`);
      courseInfo.value.selectedProfessor = teacherResponse.data.name;
    } catch (error) {
      console.error('Error fetching desired shift teacher:', error);
    }
  }
}

async function checkScheduleConflict() {
  if (!formData.value.desiredShift) return;

  try {
    // Obtém todas as alocações do estudante
    const allocationsResponse = await axios.get(`http://localhost:3000/allocations?studentId=${user.id}`);
    const studentAllocations = allocationsResponse.data;

    // Obtém todos os turnos dessas alocações
    const shiftsPromises = studentAllocations.map(allocation => 
      axios.get(`http://localhost:3000/shifts/${allocation.shiftId}`)
    );
    const shiftsResponses = await Promise.all(shiftsPromises);
    const studentShifts = shiftsResponses.map(response => response.data);

    // Verifica conflitos de horário
    const desiredShift = formData.value.desiredShift;
    hasScheduleConflict.value = studentShifts.some(shift => {
      // Ignora o turno atual (que será trocado)
      if (formData.value.currentShift && shift.id === formData.value.currentShift.id) {
        return false;
      }
      
      // Verifica se é o mesmo dia e se há sobreposição de horários
      return shift.day === desiredShift.day && 
              ((desiredShift.from >= shift.from && desiredShift.from < shift.to) ||
              (desiredShift.to > shift.from && desiredShift.to <= shift.to) ||
              (desiredShift.from <= shift.from && desiredShift.to >= shift.to));
    });
  } catch (error) {
    console.error('Error checking schedule conflicts:', error);
    hasScheduleConflict.value = false;
  }
}

// Submete o pedido de troca
async function submitRequest() {
  if (!isFormComplete.value || hasScheduleConflict.value) {
    showErrorToast.value = true;
    setTimeout(() => {
      showErrorToast.value = false;
    }, 5000);
    return;
  }
  
  try {
    const requestData = {
      fromShift: formData.value.currentShift.id,
      toShift: formData.value.desiredShift.id,
      studentId: user.id,
      response: "pending",
      reason: formData.value.reason,
      date: new Date()
    };

    const response = await axios.post('http://localhost:3000/shiftRequests', requestData);
    if (response.status === 201) {
      const notificationResponse = await axios.post('http://localhost:3000/notifications', {
        userId: 'jose@di.uminho.pt',
        type: 'Troca de Turno',
        date: new Date(),
        title: 'Pedido de Troca de Turno',
        message: 'O/A aluno/a ' + user.name + ' fez um pedido de troca de turno. O mesmo tem de ser revisto.',
        read: 'false'
      });
      router.push({ name: 'inicio-aluno', query: { showSuccessToast: 'true' } });
    }
  } catch (error) {
    console.error('Error submitting request:', error);
    showErrorToast.value = true;
    setTimeout(() => {
      showErrorToast.value = false;
    }, 5000);
  }
}

function getDay(day) {
  switch(day) {
    case 'Monday': return '2ª Feira';
    case 'Tuesday': return '3ª Feira';
    case 'Wednesday': return '4ª Feira';
    case 'Thursday': return '5ª Feira';
    case 'Friday': return '6ª Feira';
    default: return '';
    }
  }

// Observa mudanças na UC para resetar os turnos
watch(() => formData.value.subject, (newSubject, oldSubject) => {
  if (newSubject !== oldSubject) {
    formData.value.currentShift = null;
    formData.value.desiredShift = null;
    hasScheduleConflict.value = false;
    availableDesiredShifts.value = [];
  }
});

onMounted(() => {
  getCourses();
  getConflicts();
});
</script>