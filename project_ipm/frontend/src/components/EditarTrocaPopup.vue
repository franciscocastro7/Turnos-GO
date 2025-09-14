<template>
  <div v-if="show"
    class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 overflow-y-auto p-2 sm:p-4">
    <ErrorToast v-if="showErrorToast" />
    <div
      class="bg-[#252422] relative rounded-xl sm:rounded-2xl shadow-lg w-full max-w-[1250px] p-3 sm:p-4 md:p-6 animate-fade-in max-h-[90vh] overflow-y-auto my-8">
      <!-- Header -->
      <div class="mb-3 sm:mb-6">
        <h2 class="text-xl sm:text-2xl md:text-3xl font-bold text-white">Troca de Turno - <span class="text-orange">{{
          aluno.numero }}</span></h2>
      </div>

      <button @click="$emit('close')" class="absolute top-2 right-2 sm:top-4 sm:right-4 text-orange-400">
        <X class="w-5 h-5 sm:w-6 sm:h-6 md:w-8 md:h-8 text-orange" />
      </button>

      <!-- Student Info -->
      <div class="mb-3 sm:mb-4 border border-[#69655F] rounded-lg p-2 sm:p-3">
        <h3 class="font-semibold text-white mb-1 sm:mb-2 text-lg sm:text-xl">Informação do Aluno</h3>
        <div
          class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-1 sm:gap-2 text-sm sm:text-base text-white p-2 sm:p-3 md:p-5">
          <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
              <User class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Nome:
            </strong> <span class="text-text_gray sm:ml-2 pl-5 sm:pl-0">{{ aluno.nome }}</span></div>
          <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
              <Mail class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Email:
            </strong> <span class="text-text_gray sm:ml-2 pl-5 sm:pl-0">{{ aluno.email }}</span></div>
          <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
              <BriefcaseBusiness class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Estatuto:
            </strong> <span class="text-text_gray sm:ml-2 pl-5 sm:pl-0">{{ aluno.estatuto }}</span></div>
          <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
              <IdCard class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Nº de Aluno:
            </strong> <span class="text-text_gray sm:ml-2 pl-5 sm:pl-0">{{ aluno.numero }}</span></div>
          <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
              <CalendarRange class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Ano Curricular:
            </strong> <span class="text-text_gray sm:ml-2 pl-5 sm:pl-0">{{ aluno.ano }}</span></div>
          <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
              <Smartphone class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Telemóvel:
            </strong> <span class="text-text_gray sm:ml-2 pl-5 sm:pl-0">{{ aluno.telemovel }}</span></div>
        </div>
      </div>

      <!-- Container for two boxes -->
      <div class="flex flex-col md:flex-row md:justify-between gap-3 sm:gap-4 mb-3 sm:mb-4">
        <!-- Exchange Info -->
        <div class="w-full md:w-1/2 border border-[#69655F] rounded-lg p-2 sm:p-3">
          <h3 class="font-semibold text-white mb-1 sm:mb-2 text-lg sm:text-xl">Informações sobre a troca</h3>
          <div class="grid grid-cols-1 gap-2 sm:gap-4 text-sm sm:text-base text-white p-2 sm:p-3 md:p-4">
            <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
                <BookText class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Unidade Curricular:
              </strong> <span class="text-text_gray sm:ml-2 pl-5 sm:pl-0">{{ troca.uc }}</span></div>
            <div class="flex flex-col sm:flex-row sm:items-start">
              <strong class="flex items-center gap-1 sm:gap-2 shrink-0">
                <MessageSquareText class="text-orange w-3 h-3 sm:w-4 sm:h-4" />
                Motivo da Troca:
              </strong>
              <span class="text-text_gray sm:ml-2 break-words pl-5 sm:pl-0">{{ troca.motivo }}</span>
            </div>
            <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
                <FlagTriangleRight class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Turno Atual:
              </strong> <span class="text-text_gray sm:ml-2 pl-5 sm:pl-0">{{ troca.turnoAtual }}</span></div>
            <div class="flex flex-col sm:flex-row sm:items-center sm:-mt-4 pl-5 sm:pl-6"><strong
                class="flex items-center gap-1 sm:gap-2">Horário Atual:</strong> <span class="text-text_gray sm:ml-2">{{
                  troca.horarioAtual }}</span></div>
            <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
                <Goal class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Turno Desejado:
              </strong> <span class="text-text_gray sm:ml-2 pl-5 sm:pl-0">{{ troca.turnoDesejado }}</span></div>
            <div class="flex flex-col sm:flex-row sm:items-center sm:-mt-4 pl-5 sm:pl-6"><strong
                class="flex items-center gap-1 sm:gap-2">Horário Desejado:</strong> <span
                class="text-text_gray sm:ml-2">{{ troca.horarioDesejado }}</span></div>
          </div>
        </div>

        <!-- New Shift -->
        <div class="w-full md:w-1/2 border border-[#69655F] rounded-lg p-2 sm:p-3">
          <h3 class="font-semibold text-white mb-1 sm:mb-2 text-lg sm:text-xl">Novo Turno</h3>
          <div class="grid grid-cols-1 gap-2 text-sm sm:text-base text-white p-2 sm:p-3 md:p-4">
            <select @change="getCourseInfo" v-model="formData.subject"
              class="w-full p-1 bg-background_gray border border-white-500 rounded text-white font-poppins font-semibold pl-2 sm:pl-4 mb-2 sm:mb-4 text-sm sm:text-base">
              <option v-for="turno in turnos" :key="turno.id" :value="turno">{{ turno.name }} &nbsp;({{ turno.dia }} {{
                turno.from }}h00 - {{ turno.to }}h00)</option>
            </select>
            <div v-if="troca.percentagemOcupacao > 70"
              class="flex items-center font-semibold text-xs sm:text-sm pt-3 sm:pt-8 md:pt-12">Foram sugeridos outros
              turnos da unidade curricular, com o mesmo horário, pois o turno desejado está cheio ou quase na capacidade
              máxima.</div>
            <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
                <UserRound class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Docente:
              </strong> <span class="text-white sm:ml-2 pl-5 sm:pl-0">{{ troca.docente }}</span></div>
            <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
                <House class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Sala:
              </strong> <span class="text-white sm:ml-2 pl-5 sm:pl-0">{{ troca.sala }}</span></div>
            <div class="flex flex-col sm:flex-row sm:items-center"><strong class="flex items-center gap-1 sm:gap-2">
                <Users class="text-orange w-3 h-3 sm:w-4 sm:h-4" />Ocupação:
              </strong> <span class="text-white sm:ml-2 pl-5 sm:pl-0">{{ troca.ocupacao }} &nbsp;</span><span :class="{
                'text-[#84CC16]': troca.percentagemOcupacao < 70,
                'text-orange': troca.percentagemOcupacao >= 70 && troca.percentagemOcupacao < 100,
                'text-[#DC2626]': troca.percentagemOcupacao === 100
              }">
                ({{ troca.percentagemOcupacao }}%)</span></div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-8 gap-4 lg:gap-0">
        <!-- Note - takes 5 columns on large screens -->
        <div class="lg:col-span-5">
          <trocaNota :estatuto="aluno.estatuto" />
        </div>

        <!-- Actions - takes 3 columns on large screens -->
        <div class="lg:col-span-3 lg:pl-6">
          <div class="text-white text-xs sm:text-sm md:text-base">Ao clicar <span
              class="text-orange font-bold">"aceitar/recusar"</span>, a troca será processada
            pelo que não será possível realizar <span class="text-orange">futuras alterações.</span>
          </div>
          <div class="flex justify-center lg:justify-end gap-2 sm:gap-3 pt-3 sm:pt-5">
            <button @click="recusar"
              class="px-4 sm:px-6 md:px-10 py-1 rounded-2xl sm:rounded-3xl font-semibold text-base sm:text-xl md:text-2xl bg-background_gray text-white border-orange border hover:scale-105 hover:shadow-lg transition">
              Recusar
            </button>
            <button @click="aceitar" :class="[
              'px-4 sm:px-6 md:px-10 py-1 rounded-2xl sm:rounded-3xl font-semibold text-base sm:text-xl md:text-2xl transition',
              formData.subject
                ? 'bg-orange text-white hover:bg-orange/80 hover:scale-105 hover:shadow-lg'
                : 'bg-[#403D39] text-white'
            ]">
              Aceitar
            </button>

          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { User, IdCard, Mail, CalendarRange, BriefcaseBusiness, Smartphone, BookText, MessageSquareText, FlagTriangleRight, Goal, Clock, UserRound, House, Users } from 'lucide-vue-next';
import axios from 'axios';
import trocaNota from '../components/trocaNota.vue';
import { X } from 'lucide-vue-next';
import ErrorToast from '../components/ErrorToast.vue';
import { ref } from 'vue';


export default {
  name: "EditarTrocaPopup",
  components: { X, User, IdCard, Mail, CalendarRange, BriefcaseBusiness, Smartphone, BookText, MessageSquareText, FlagTriangleRight, Goal, Clock, UserRound, House, Users, trocaNota, ErrorToast },
  props: {
    show: Boolean,
    aluno: Object,
    troca: Object,
    turnos: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      formData: {
        subject: null
      }
    }
  },
  setup() {
    const showErrorToast = ref(false);
    return { showErrorToast };
  },
  methods: {
    async aceitar() {
      if (!this.formData.subject) {
        this.showErrorToast = true;
        setTimeout(() => {
          this.showErrorToast = false;
        }, 5000);
        return;
      }
      try {
        const response = await axios.patch(`http://localhost:3000/shiftRequests/${this.troca.id}`, {
          response: 'ok'
        });

        if (response.status === 200) {
          await axios.post('http://localhost:3000/notifications', {
            userId: this.aluno.email,
            type: 'Troca de Turno',
            date: new Date(),
            title: 'Pedido de Troca Aceite',
            message: `O seu pedido de troca de turno para ${this.troca.ucAbrev} (${this.formData.subject.name}) foi aceite.`,
            read: 'false'
          });

          this.$emit('aceitar');
          this.$emit('close');
        }
      } catch (error) {
        console.error('Erro ao aceitar troca:', error);
        this.showErrorToast = true;
        setTimeout(() => {
          this.showErrorToast = false;
        }, 5000);
      }
    },

    async recusar() {
      try {
        const response = await axios.patch(`http://localhost:3000/shiftRequests/${this.troca.id}`, {
          response: 'rejected'
        });

        if (response.status === 200) {
          // Mandar notificação para o aluno
          await axios.post('http://localhost:3000/notifications', {
            userId: this.aluno.email,
            type: 'Troca de Turno',
            date: new Date(),
            title: 'Pedido de Troca Recusado',
            message: `O seu pedido de troca de turno para ${this.troca.ucAbrev} (${this.formData.subject.name}) foi recusado.`,
            read: 'false'
          });
          this.$emit('recusar');
          this.$emit('close');
        }
      } catch (error) {
        console.error('Erro ao recusar troca:', error);
        this.showErrorToast = true;
        setTimeout(() => {
          this.showErrorToast = false;
        }, 5000);
      }
    },
    getCourseInfo() {
      const selectedTurno = this.formData.subject;
      if (selectedTurno) {
        this.troca.docente = selectedTurno.docente;
        this.troca.sala = selectedTurno.salaId;
        this.troca.ocupacao = selectedTurno.ocupacao;
        this.troca.percentagemOcupacao = selectedTurno.percentagemOcupacao;
      }
    }
  }
};
</script>

<style scoped>
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