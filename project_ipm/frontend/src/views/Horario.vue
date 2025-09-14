<template>
    <div class="bg-background_gray text-white text-sm h-full min-h-screen flex flex-col overflow-auto">
        <div v-if="conflicts" class="flex flex-1 items-center justify-center flex-col">
            <p class="text-white text-lg sm:text-xl md:text-2xl font-poppins font-semibold text-center">O teu horário ainda não foi publicado.</p>
            <div class="flex justify-center items-center text-[#D9D9D9]">
                <a href="/students/home" class="underline text-lg decoration-orange">Voltar</a>
            </div>
        </div>
        <!-- Main container with time column and content -->
        <div v-if="!conflicts" class="hidden xl:flex flex-1">
            <!-- Time Column -->
            <div class="w-12 flex-shrink-0">
            <div class="h-11"></div> <!-- Header spacing -->
            <div v-for="hour in ['08H', '09H', '10H', '11H', '12H', '13H', '14H', '15H', '16H', '17H', '18H']" 
                :key="hour" 
                :class="['h-20 text-lg flex items-center justify-start border-[#D9D9D9]/40', hour !== '18H' ? 'border-b' : '']">
                {{ hour }}
            </div>
            </div>
    
            <!-- Main Content -->
            <div class="flex-1 flex flex-col">
                <!-- Header Row -->
                <div class="grid grid-cols-5 h-1 rounded-lg mt-4 mr-12">
                    <div class="bg-orange flex justify-center items-center font-semibold text-lg rounded-l-lg">Segunda-Feira</div>
                    <div class="bg-orange flex justify-center items-center font-semibold text-lg">Terça-Feira</div>
                    <div class="bg-orange flex justify-center items-center font-semibold text-lg">Quarta-Feira</div>
                    <div class="bg-orange flex justify-center items-center font-semibold text-lg">Quinta-Feira</div>
                    <div class="bg-orange flex justify-center items-center font-semibold text-lg rounded-r-lg">Sexta-Feira</div>
                </div>
    
                <!-- Time Slots Grid -->
                <div class="flex-1">
                    <div class="h-6"></div> 
                    <div v-for="(hour, hourIndex) in ['08H', '09H', '10H', '11H', '12H', '13H', '14H', '15H', '16H', '17H', '18H']" 
                        :key="hour" 
                        class="grid grid-cols-5 h-20 mr-12">
                        <div v-for="(day, dayIndex) in 5" :key="day" 
                            :class="[
                                'relative',
                                dayIndex < 4 ? 'border-r' : '',
                                hourIndex < 10 ? 'border-b' : '',
                                'border-[#D9D9D9]/40 border-x-[#403D39]'
                            ]">
                            <template v-for="horario in horarios" :key="horario.id">
                                <CardTurno
                                    v-if="getHourFromTime(horario.horario) === hour && getDayIndex(horario.shiftDay) === dayIndex"
                                    :uc="horario.uc"
                                    :abbreviation="horario.abbreviation"
                                    :tipo="horario.tipo"
                                    :horario="horario.horario"
                                    :sala="horario.sala"
                                    :ano="horario.ano"
                                    class="absolute inset-1 ml-0.5"
                                />
                            </template>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div v-if="!conflicts" class="xl:hidden flex flex-1 flex-col">
            <!-- Day selector tabs -->
            <div class="flex w-full sticky pt-20 bg-background_gray z-10 rounded-lg">
                <button 
                v-for="(day, index) in ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta']" 
                :key="day"
                @click="selectedDay = index"
                class="flex-1 py-2 text-center font-medium"
                :class="selectedDay === index ? 'bg-orange text-white' : 'bg-[#403D39] text-gray-300'"
                >
                {{ day }}
                </button>
            </div>

            <!-- Selected day schedule -->
            <div class="flex-1 px-4 py-4 pb-12">
                <div 
                v-for="horario in filteredHorarios" 
                :key="horario.id"
                class="mb-3 bg-[#403D39] rounded-lg p-3 border-l-4 border-orange"
                >
                    <div class="flex justify-between items-center mb-1">
                        <span class="font-semibold text-base">{{ horario.abbreviation }}</span>
                        <span class="text-gray-300 text-sm">{{ horario.tipo }}</span>
                    </div>
                    <div class="text-gray-300 text-sm">{{ horario.horario }}</div>
                    <div class="text-gray-300 text-sm">Sala: {{ horario.sala }}</div>
                    <div class="text-gray-400 text-xs mt-1">{{ horario.ano }}</div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>

import CardTurno from '@/components/cardTurno.vue'
import { useAuthStore } from '@/stores/auth'
import axios from 'axios'
import { ref, onMounted, computed } from 'vue'

const slotIds = ref([]);

const horarios = ref([{
    id: '',
    uc: '',
    tipo: '',
    horario: '',
    sala: '',
    ano: '',
    shiftDay: '',
}]);

const conflicts = ref(true)

const selectedDay = ref(0)

const filteredHorarios = computed(() => {
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']
    return horarios.value.filter(horario => 
        horario.shiftDay?.toLowerCase() === days[selectedDay.value]
    )
})

const authStore = useAuthStore()
const user = authStore.user

async function getConflicts() {
    try {
        const response = await axios.get(`http://localhost:3000/conflicts?studentId=${user.id}`)
        const allocations = response.data

        if(allocations.length > 0) {
            conflicts.value = true
        } else {
            conflicts.value = false
        }
    } catch (error) {
        console.error('Error fetching conflicts:', error)
    }
}

async function getClassroom(classroomId) {
    try {
        const response = await axios.get(`http://localhost:3000/classrooms/${classroomId}`)
        return response.data
    } catch (error) {
        console.error('Error fetching classroom:', error)
        return null
    }
}

async function getCourse(courseId) {
    try {
        const response = await axios.get(`http://localhost:3000/courses/${courseId}`)
        return response.data
    } catch (error) {
        console.error('Error fetching course:', error)
        return null
    }
}

async function getHorarios() {
    try {
        const allocationsResponse = await axios.get(`http://localhost:3000/allocations?studentId=${user.id}`)
        slotIds.value = allocationsResponse.data.map(slot => slot.shiftId)

        for (const slot of slotIds.value) {
            try {
                const shiftResponse = await axios.get(`http://localhost:3000/shifts/${slot}`)
                const shift = shiftResponse.data

                const horario = getHorarioFromTime(shift.from, shift.to)

                const classroom = await getClassroom(shift.classroomId)
                const course = await getCourse(shift.courseId)
                const ano = course.year + "º Ano - " + course.semester + "º Sem"

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
                    })
                }
            } catch (error) {
                console.error('Error fetching shift:', error)
            }
        }
    } catch (error) {
        console.error('Error fetching allocations:', error)
    }
}

function getHorarioFromTime(from, to) {
    const start = from + ':00'
    const end = to + ':00'
    return `${start} - ${end}`
}

function getHourFromTime(time) {
    const start = time.split(' - ')[0]
    const startTime = start.split(':')[0]
    return `${startTime}H`
}

function getDayIndex(dayName) {
    const dayMap = {
        'monday': 0,
        'tuesday': 1,
        'wednesday': 2,
        'thursday': 3,
        'friday': 4
    }
    return dayMap[dayName.toLowerCase()] || 0
}

onMounted(() => {
    getConflicts()
    getHorarios()
})
</script>