<template>
    <div class="h-full min-h-screen bg-background_gray flex flex-col font-poppins">
        <h1 class="pt-20 pb-10 px-20 font-bold text-4xl 2xl:text-5xl text-white">
            Olá, <span class="text-orange">{{ name }}!</span>
        </h1>
        <div class="flex items-center justify-between w-full">
            <div class="pt-5 pb-10 px-8 xl:px-20 grid grid-cols-2 gap-4 items-stretch justify-items-stretch w-full">
                <div
                    class="flex justify-center items-center border-[#69655F] w-full h-28 rounded-lg text-white flex-col border-2 space-y-1 text-center">
                    <p class="text-lg sm:text-xl md:text-2xl font-semibold">Total de Pedidos</p>
                    <p class="text-base sm:text-xl md:text-2xl text-orange font-semibold">{{ totalRequests }} pedidos
                        registados</p>
                </div>
                <div
                    class="flex justify-center items-center flex-col border-2 border-[#69655F] w-full h-28 rounded-lg space-y-1 text-center">
                    <p class="text-white text-lg sm:text-xl md:text-2xl font-semibold">Pedidos aprovados</p>
                    <p class="text-base sm:text-xl md:text-2xl text-[#00ED51] font-semibold">{{ totalApproved }}</p>
                </div>
                <div
                    class="flex justify-center items-center border-2 border-[#69655F] w-full h-28 rounded-lg flex-col space-y-1 text-center">
                    <p class="text-lg sm:text-xl md:text-2xl text-white font-semibold">Salas disponíveis</p>
                    <p class="text-base sm:text-xl md:text-2xl text-[#00ED51] font-semibold">{{ freeClassrooms }} salas
                        livres</p>
                </div>
                <div
                    class="flex justify-center items-center border-2 border-[#69655F] w-full h-28 rounded-lg flex-col space-y-1 text-center">
                    <p class="text-lg sm:text-xl md:text-2xl text-white font-semibold">Pedidos rejeitados</p>
                    <p class="text-base sm:text-xl md:text-2xl text-[#DC2626] font-semibold">{{ totalRejected }}</p>
                </div>
            </div>
        </div>
        <div class="w-full px-8 xl:px-20">
            <div class="flex flex-col justify-center border-2 border-[#69655F] rounded-lg p-6 bg-background_gray">
                <h1 class="text-lg sm:text-xl md:text-2xl  text-white font-semibold pb-2">Pedidos Pendentes</h1>
                <div class="max-h-[140px] overflow-y-auto">
                    <div v-for="request in classroomRequests" class="flex items-center space-x-4">
                        <span class="w-3 h-3 bg-orange rounded-full"></span>
                        <a href="/directors/consultar-turnos">  
                            <p class="text-base sm:text-xl md:text-2xl text-white underline">{{ request }} - Troca de
                                Sala
                            </p>
                        </a>
                    </div>
                    <div v-for="request in shiftRequests" class="flex items-center space-x-4 py-4">
                        <span class="w-3 h-3 bg-orange rounded-full"></span>
                        <a href="/directors/pedidos-troca">
                            <p class="text-base sm:text-xl md:text-2xl text-white underline">{{ request }} - Troca de
                                Turno
                            </p>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div v-if="conflicts"
            class="flex flex-col sm:flex-row items-center justify-center bg-orange mt-10 rounded-2xl px-4 sm:px-8 md:px-10 py-4 gap-4 sm:gap-6 md:gap-10 w-[85%] mb-6 md:w-[85%] xl:w-[90%] 2xl:w-[70%] mx-auto">
            <TriangleAlert class="h-8 w-8 sm:h-10 sm:w-10 md:w-12 md:h-12 text-white" />
            <h1 class="text-white w-full text-sm sm:text-base md:text-lg text-center sm:text-left font-medium">
                Não foi possível alocar alguns alunos sem gerar conflitos nos seus horários.
                <br />Proceda à alocação manual dos mesmos.
            </h1>
        </div>

        <!-- Falta ver isto na questão responsividade! -->
        <div class="absolute bottom-5 right-0 left-72 text-white text-xs md:text-sm hidden xl:block">
            <p class="text-center">
                Feito por: João Sá <span class="text-orange">/</span> João Cunha <span class="text-orange">/</span>
                Francisco Castro <span class="text-orange">/</span> Gonçalo Alves <span class="text-orange">/</span>
                Rodrigo Ferreira
            </p>
        </div>
    </div>
</template>

<script setup>
import { TriangleAlert } from 'lucide-vue-next';
import { ref, onMounted } from 'vue';
import { useAuthStore } from '@/stores/auth.js';
import axios from 'axios';

const authStore = useAuthStore();
const name = authStore.user.name;

var totalRequests = ref(0);
var totalApproved = ref(0);
var totalRejected = ref(0);
var freeClassrooms = ref(0);
var conflicts = ref(false)

const classroomRequests = ref([]);
const shiftRequests = ref([]);

async function getRequests() {
    await axios.get('http://localhost:3000/classroomRequests', {
    })
        .then(response => {
            var auxTotal = response.data.length;
            var auxApproved = response.data.filter(request => request.response === 'ok').length
            var auxRejected = response.data.filter(request => request.response === 'rejected').length

            var requestIDs = response.data.filter(request => request.response === 'pending').map(id => id.teacherId);

            requestIDs.forEach(element => {
                axios.get(`http://localhost:3000/teachers/${element}`, {
                })
                    .then(response => {
                        var id = response.data.teacher.name;
                        classroomRequests.value.push(id)
                    })
                    .catch(error => {
                        console.error('Error fetching teacher data:', error);
                    });
            });

            axios.get('http://localhost:3000/shiftRequests', {
            })
                .then(response => {
                    totalRequests.value = auxTotal + response.data.length;
                    totalApproved.value = response.data.filter(request => request.response === 'ok').length + auxApproved;
                    totalRejected.value = response.data.filter(request => request.response === 'rejected').length + auxRejected;

                    var requestIDs = response.data.filter(request => request.response === 'pending').map(id => id.studentId);

                    requestIDs.forEach(element => {
                        axios.get(`http://localhost:3000/students/${element}`, {
                        })
                            .then(response => {
                                const id = response.data.email.split('@')[0].toUpperCase();
                                shiftRequests.value.push(id)
                            })
                            .catch(error => {
                                console.error('Error fetching student data:', error);
                            });
                    });
                })
                .catch(error => {
                    console.error('Error fetching shift requests:', error);
                });
        })
        .catch(error => {
            console.error('Error fetching classroom requests:', error);
        });
}

async function getClassrooms() {
    await axios.get('http://localhost:3000/classrooms', {
    })
        .then(response => {
            freeClassrooms.value = response.data.length
        })
        .catch(error => {
            console.error('Error fetching classrooms:', error);
        });
}

async function getConflicts() {
    try {
        const response = await axios.get(`http://localhost:3000/conflicts`);
        const allocations = response.data;

        if (allocations.length > 0) {
            conflicts.value = true;
        } else {
            conflicts.value = false;
        }
    } catch (error) {
        console.error('Error fetching conflicts:', error);
    }
}


onMounted(async () => {
    await getRequests();
    await getClassrooms();
    await getConflicts();
});
</script>