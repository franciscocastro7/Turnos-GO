<template>
  <div v-if="show"
    class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 px-2 overflow-y-auto animate-fade-in">
    <div
      class="bg-[#252422] rounded-2xl p-4 sm:p-8 max-w-[90vh] sm:max-w-5xl w-full relative max-h-[90vh] overflow-y-auto">
      <button @click="$emit('close')" class="top-12 right-6 sm:top-4 sm:right-4 text-orange-400 text-xl fixed md:absolute">
        <X class="w-6 h-6 sm:w-8 sm:h-8 text-orange" />
      </button>
      <h2 class="text-white text-2xl sm:text-3xl font-semibold text-center mb-6 sm:mb-8">
        Meu Horário
      </h2>

      <!-- Conteúdo do horário -->
      <div class="bg-background_gray text-white text-sm">
        <div v-if="conflicts" class="flex items-center justify-center flex-col p-8">
          <p class="text-xl text-white font-semibold">O teu horário ainda não foi publicado.</p>
        </div>

        <!-- Main container with time column and content -->
        <div v-else class="flex">
          <!-- Time Column -->
          <div class="w-12 flex-shrink-0">
            <div class="h-8"></div> <!-- Header spacing -->
            <div v-for="hour in ['08H', '09H', '10H', '11H', '12H', '13H', '14H', '15H', '16H', '17H', '18H']"
              :key="hour"
              :class="['h-16 text-base flex items-center justify-start border-[#D9D9D9]/40', hour !== '18H' ? 'border-b' : '']">
              {{ hour }}
            </div>
          </div>

          <!-- Main Content -->
          <div class="flex-1 flex flex-col">
            <!-- Header Row -->
            <div class="grid grid-cols-5 h-8 rounded-lg mt-0 mr-4 w-[600px] md:w-auto scroll-x-auto">
              <div class="bg-orange flex justify-center items-center font-semibold text-sm rounded-l-lg">Segunda</div>
              <div class="bg-orange flex justify-center items-center font-semibold text-sm">Terça</div>
              <div class="bg-orange flex justify-center items-center font-semibold text-sm">Quarta</div>
              <div class="bg-orange flex justify-center items-center font-semibold text-sm">Quinta</div>
              <div class="bg-orange flex justify-center items-center font-semibold text-sm rounded-r-lg">Sexta</div>
            </div>

            <!-- Time Slots Grid -->
            <div class="flex-1">
              <div class="h-0"></div>
              <div
                v-for="(hour, hourIndex) in ['08H', '09H', '10H', '11H', '12H', '13H', '14H', '15H', '16H', '17H', '18H']"
                :key="hour" class="grid grid-cols-5 h-16 mr-4">
                <div v-for="(day, dayIndex) in 5" :key="day" :class="[
                  'relative',
                  dayIndex < 4 ? 'border-r' : '',
                  hourIndex < 10 ? 'border-b' : '',
                  'border-[#D9D9D9]/40 border-x-[#403D39]'
                ]">
                  <template v-for="horario in horarios" :key="horario.id">
                    <div v-if="getHourFromTime(horario.horario) === hour && getDayIndex(horario.shiftDay) === dayIndex"
                      class="absolute inset-1 ml-0.5 rounded bg-orange bg-opacity-80 p-1 text-xs overflow-hidden">
                      <div class="font-bold">{{ horario.abbreviation }}</div>
                      <div>{{ horario.tipo }}</div>
                      <div>{{ horario.sala }}</div>
                    </div>
                  </template>

                  <div v-if="showDesiredShiftCard(hour, dayIndex)"
                    class="absolute inset-1 ml-20 rounded bg-[#7A2D84] p-1 text-xs overflow-hidden z-20 ">
                    <div class="font-bold">{{ desiredShiftCourse?.abbreviation || 'Curso' }}</div>
                    <div>{{ desiredShift?.name || 'Aula' }}</div>
                    <div>{{ desiredShiftClassroom?.name || 'Sala' }}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { watch, ref, onMounted, computed } from 'vue';
import { X } from 'lucide-vue-next';
import { useAuthStore } from '@/stores/auth';
import axios from 'axios';

export default {
  name: "SchedulePopup",
  props: {
    show: Boolean,
    desiredShift: {
      type: Object,
      required: false,
      default: null
    }
  },
  components: {
    X
  },
  emits: ['close'],
  setup(props, { emit }) {
    const slotIds = ref([]);
    const conflicts = ref(true);
    const authStore = useAuthStore();
    const user = authStore.user;
    const desiredShiftCourse = ref(null);
    const desiredShiftClassroom = ref(null);

    const horarios = ref([{
      id: '',
      uc: '',
      tipo: '',
      horario: '',
      sala: '',
      ano: '',
      shiftDay: '',
      abbreviation: ''
    }]);

    watch(() => props.desiredShift, async (newVal) => {
      if (newVal) {
        try {
          desiredShiftCourse.value = await getCourse(newVal.courseId);
          desiredShiftClassroom.value = await getClassroom(newVal.classroomId);
        } catch (error) {
          console.error('Error loading desired shift details:', error);
          desiredShiftCourse.value = null;
          desiredShiftClassroom.value = null;
        }
      } else {
        desiredShiftCourse.value = null;
        desiredShiftClassroom.value = null;
      }
    }, { immediate: true });

    watch(() => props.show, (newVal) => {
      if (newVal) {
        getConflicts();
        getHorarios();
      }
    });

    const showDesiredShiftCard = (hour, dayIndex) => {
      if (!props.desiredShift) return false;

      const desiredHour = getHourFromTime(
        getHorarioFromTime(props.desiredShift.from, props.desiredShift.to)
      );

      return desiredHour === hour &&
        getDayIndex(props.desiredShift.day) === dayIndex;
    };

    async function getConflicts() {
      try {
        const response = await axios.get(`http://localhost:3000/conflicts?studentId=${user.id}`);
        conflicts.value = response.data.length > 0;
      } catch (error) {
        console.error('Error fetching conflicts:', error);
        conflicts.value = true;
      }
    }

    async function getClassroom(classroomId) {
      try {
        const response = await axios.get(`http://localhost:3000/classrooms/${classroomId}`);
        return response.data;
      } catch (error) {
        console.error('Error fetching classroom:', error);
        return null;
      }
    }

    async function getCourse(courseId) {
      try {
        const response = await axios.get(`http://localhost:3000/courses/${courseId}`);
        return response.data;
      } catch (error) {
        console.error('Error fetching course:', error);
        return null;
      }
    }

    async function getHorarios() {
      try {
        horarios.value = [{
          id: '',
          uc: '',
          tipo: '',
          horario: '',
          sala: '',
          ano: '',
          shiftDay: '',
          abbreviation: ''
        }];

        const allocationsResponse = await axios.get(`http://localhost:3000/allocations?studentId=${user.id}`);
        slotIds.value = allocationsResponse.data.map(slot => slot.shiftId);

        for (const slot of slotIds.value) {
          try {
            const shiftResponse = await axios.get(`http://localhost:3000/shifts/${slot}`);
            const shift = shiftResponse.data;

            const horario = getHorarioFromTime(shift.from, shift.to);
            const classroom = await getClassroom(shift.classroomId);
            const course = await getCourse(shift.courseId);
            const ano = course?.year ? `${course.year}º Ano - ${course.semester}º Sem` : '';

            if (classroom && course) {
              horarios.value.push({
                id: shift.id,
                uc: course.name,
                abbreviation: course.abbreviation,
                tipo: shift.name,
                horario: horario,
                sala: classroom.name,
                ano: ano,
                shiftDay: shift.day,
              });
            }
          } catch (error) {
            console.error('Error fetching shift:', error);
          }
        }
      } catch (error) {
        console.error('Error fetching allocations:', error);
      }
    }

    function getHorarioFromTime(from, to) {
      const start = from + ':00';
      const end = to + ':00';
      return `${start} - ${end}`;
    }

    function getHourFromTime(time) {
      const start = time.split(' - ')[0];
      const startTime = start.split(':')[0];
      return `${startTime}H`;
    }

    function getDayIndex(dayName) {
      const dayMap = {
        'monday': 0,
        'tuesday': 1,
        'wednesday': 2,
        'thursday': 3,
        'friday': 4
      };
      return dayMap[dayName.toLowerCase()] || 0;
    }

    onMounted(() => {
      if (props.show) {
        getConflicts();
        getHorarios();
      }
    });

    return {
      conflicts,
      horarios,
      desiredShiftCourse,
      desiredShiftClassroom,
      getHourFromTime,
      getHorarioFromTime,
      getDayIndex,
      showDesiredShiftCard
    };
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