<template>
  <div class="bg-background_gray h-screen w-full  flex flex-col font-poppins">

    <h1 class="px-20 xl:px-8 py-8 md:py-7 xl:py-10 text-sm md:text-lg font-poppins font-semibold text-white">
      <span class="text-white/50">Gestão de Turnos / <a class="underline hover:text-white/80 "
          href="/directors/consultar-turnos">Consultar Turnos</a></span>
      <span class="text-white"> / {{ course.abbreviation }}</span>
    </h1>

    <div class="p-8">
      <h2 class="text-xl md:text-2xl lg:text-3xl xl:text-5xl font-semibold text-white mb-2">
        Lista de Turnos de <span class="text-[#EB5E28] font-bold">{{ course.name }}</span>
      </h2>

      <div class="overflow-x-auto mt-6 text-base">
        <table class="w-full text-white text-left border-collapse">
          <thead>
            <tr class="border-b-2 border-text-gray text-text_gray border-[#69655F]">
              <th class="px-4 py-2 text-lg">Docente</th>
              <th class="px-4 py-2">Turno</th>
              <th class="px-4 py-2">Horário</th>
              <th class="px-4 py-2">Ocupação</th>
              <th class="px-4 py-2">Sala</th>
              <th class="px-4 py-2">Editar</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(turno, index) in turnos" :key="index"
              class="border-b border-text-gray border-[#69655F] hover:bg-[#3A2B24]/60 transition-all">
              <td class="px-4 py-3">{{ turno.docente }}</td>
              <td class="px-4 py-3">{{ turno.turno }}</td>
              <td class="px-4 py-3">{{ turno.horario }}</td>
              <td class="px-4 py-3">
                {{ turno.ocupacao.split(' ')[0] }}
                <span :class="getOcupacaoColor(turno.ocupacao)">
                  {{ turno.ocupacao.match(/\(\d+%\)/)[0] }}
                </span>
              </td>
              <td class="px-4 py-3">{{ turno.sala.name }}</td>
              <td class="px-4 py-3">
                <button class="text-orange flex items-center text-center" aria-label="Abrir Turno"
                  @click="abrirPopup(turno)">
                  <SquarePen class="w-7 h-7" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="absolute bottom-5 right-0 left-72 text-white text-sm hidden xl:block">
        <p class="text-center">
          Feito por: João Sá <span class="text-[#EB5E28]">/</span> João Cunha
          <span class="text-[#EB5E28]">/</span> Francisco Castro <span class="text-[#EB5E28]">/</span> Gonçalo Alves
          <span class="text-[#EB5E28]">/</span> Rodrigo Ferreira
        </p>
      </div>

      <!-- Componente Popup -->
      <EditarTurnoPopup v-if="course && typeof course === 'object'" :show="popupVisivel" :turno="turnoSelecionado"
        :course="course" :salas="salasDisponiveis" @close="popupVisivel = false" @concluir="refresh"
        @success="handleSuccess" @error="handleError" @alert="handleAlert" />
    </div>
    <SuccessToast v-if="showSuccessToast" />
    <AlertToast v-if="showAlertToast" />
    <ErrorToast v-if="showErrorToast" />
  </div>
</template>

<script>
import { CirclePlus, SquareArrowLeft, SquareArrowRight, SquarePen } from 'lucide-vue-next';
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import AlertToast from '@/components/AlertToast.vue';
import ErrorToast from '@/components/ErrorToast.vue';
import SuccessToast from '@/components/SuccessToast.vue';
import axios from 'axios';
import EditarTurnoPopup from '@/components/EditarTurnoPopup.vue';

export default {
  name: "ConsultarTurnosDiretorCadeira",
  components: {
    CirclePlus,
    SquareArrowLeft,
    SquareArrowRight,
    SquarePen,
    EditarTurnoPopup,
    AlertToast,
    ErrorToast,
    SuccessToast
  },
  props: {
    id: {
      type: String,
      required: true
    }
  },
  setup() {
    const route = useRoute();
    const turnos = ref([]);
    const course = ref('');
    const searchQuery = ref("");
    const currentPage = ref(1);

    const popupVisivel = ref(false);
    const turnoSelecionado = ref({});
    const salasDisponiveis = ref([]);

    const showSuccessToast = ref(false);
    const showErrorToast = ref(false);
    const showAlertToast = ref(false);

    const handleSuccess = () => {
      showSuccessToast.value = true;
      setTimeout(() => {
        showSuccessToast.value = false;
      }, 5000);
    };

    const handleError = () => {
      showErrorToast.value = true;
      setTimeout(() => {
        showErrorToast.value = false;
      }, 5000);
    };

    const handleAlert = () => {
      showAlertToast.value = true;
      setTimeout(() => {
        showAlertToast.value = false;
      }, 5000);
    };

    async function getSalasDisponiveis(capacidadeTurno) {
      try {
        const response = await axios.get(`http://localhost:3000/classrooms`);
        const salas = response.data


        const filteredClassrooms = salas.filter(sala => sala.capacity >= capacidadeTurno);

        salasDisponiveis.value = filteredClassrooms.map(sala => ({
          id: sala.id,
          nome: sala.name,
          capacidade: sala.capacity
        }));
      } catch (error) {
        console.error('Erro ao buscar salas:', error);
      }
    }

    async function abrirPopup(turno) {
      try {
        const alunos = [];

        const response = await axios.get(`http://localhost:3000/allocations?shiftId=${turno.id}`);
        const data = response.data;

        if (data.length === 0) {
          turnoSelecionado.value = {
            ...turno,
            totalStudents: 0,
            alunos: [],
            limiteAlunos: parseInt(turno.ocupacao.split('/')[1])
          };
        } else {
          for (const allocation of data) {
            const alunosResponse = await axios.get(`http://localhost:3000/students/${allocation.studentId}`);
            alunos.push({
              name: `${alunosResponse.data.name} - ${alunosResponse.data.email.split('@')[0].toUpperCase()}`,
              email: alunosResponse.data.email
            });
          }

          turnoSelecionado.value = {
            ...turno,
            totalStudents: parseInt(turno.ocupacao.split('/')[0]),
            alunos,
            limiteAlunos: parseInt(turno.ocupacao.split('/')[1])
          };
        }


        // Limpa salas antes de carregar
        salasDisponiveis.value = [];
        await getSalasDisponiveis(turnoSelecionado.value.limiteAlunos);

        popupVisivel.value = true;
      } catch (error) {
        console.error('Erro ao abrir popup:', error);
      }
    }


    function getDay(type) {
      switch (type) {
        case 'Monday': return '2ª F';
        case 'Tuesday': return '3ª F';
        case 'Wednesday': return '4ª F';
        case 'Thursday': return '5ª F';
        case 'Friday': return '6ª F';
        default: return '';
      }
    }

    async function getTurnos() {
      try {
        const response = await axios.get(`http://localhost:3000/shifts?courseId=${route.params.id}`);
        turnos.value = await Promise.all(response.data.map(async (turno) => {
          const day = getDay(turno.day);
          const timeString = `${day} - ${turno.from}h - ${turno.to}h`;
          const percentage = Math.round((turno.totalStudentsRegistered / turno.studentLimit) * 100);
          const ocupation = `${turno.totalStudentsRegistered}/${turno.studentLimit} (${percentage}%)`;
          const teacherResponse = await axios.get(`http://localhost:3000/teachers/${turno.teacherId}`);
          const classroomResponse = await axios.get(`http://localhost:3000/classrooms/${turno.classroomId}`);
          return {
            id: turno.id,
            docente: teacherResponse.data.name,
            turno: turno.name,
            horario: timeString,
            ocupacao: ocupation,
            sala: classroomResponse.data
          };
        }));
      } catch (error) {
        console.error('Erro ao buscar turnos:', error);
      }
    }

    async function getCourse() {
      try {
        const response = await axios.get(`http://localhost:3000/courses/${route.params.id}`);
        course.value = response.data;
      } catch (error) {
        console.error('Erro ao buscar curso:', error);
      }
    }

    function refresh() {
      getTurnos();
      popupVisivel.value = false
    }

    onMounted(() => {
      getCourse();
      getTurnos();
    });

    return {
      turnos,
      course,
      currentPage,
      searchQuery,
      popupVisivel,
      turnoSelecionado,
      salasDisponiveis,
      abrirPopup,
      refresh,
      showSuccessToast,
      showErrorToast,
      showAlertToast,
      handleSuccess,
      handleError,
      handleAlert
    };
  },
  methods: {
    getOcupacaoColor(ocupacao) {
      const percentage = parseInt(ocupacao.match(/\d+(?=%)/)[0]);
      if (percentage >= 90) return "text-red-600 font-semibold";
      if (percentage >= 70) return "text-orange font-semibold";
      if (percentage >= 50) return "text-yellow-400 font-semibold";
      return "text-lime-500 font-semibold";
    }
  }
};
</script>
