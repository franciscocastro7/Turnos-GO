<template>
    <div class="bg-background_gray min-h-screen w-full flex flex-col font-poppins">
        <h1 v-if="filteredTrocas.length !== 0" class="px-20 xl:px-8 py-8 md:py-7 xl:py-10 text-sm md:text-lg font-poppins font-semibold text-white pb-6">
            <span class="font-poppins text-white/50">Gestão de Turnos /</span> Histórico de Trocas
        </h1>

        <div v-if="filteredTrocas.length === 0" class="flex-grow flex flex-col justify-center items-center">
            <span class="text-white text-lg sm:text-xl md:text-2xl font-poppins font-semibold text-center">
                Ainda não efetuaste nenhuma troca
            </span>
            <div class="flex justify-center items-center text-[#D9D9D9]">
                <a href="/students/requisitar-troca" class="underline text-xl decoration-orange">Requisitar Troca</a>
            </div>
        </div>

        <div v-if="filteredTrocas.length !== 0"  class="p-8">
            <!-- Filtros -->
            <div class="flex items-center pb-4">
                <input type="text" placeholder="Filtrar por UC..." aria-label="Filtrar Por UC"
                    class="px-2 bg-background_gray placeholder-text_gray text-text_gray rounded-md w-1/2 lg:w-1/4 border-2 border-[#69655F] focus-visible: outline-none mr-4"
                    v-model="searchQuery" />
                <div class="relative">
                    <button @click="handleFilterClick" aria-label="Handle Filter"
                        class="flex items-center gap-4 bg-background_gray px-2 rounded-md border-2 transition-all"
                        :class="[
                            selectedEstado
                                ? 'border-orange text-white border-solid'
                                : 'border-[#69655F] text-white/50 border-dashed hover:border-orange hover:text-white hover:border-solid'
                        ]">
                        <CircleMinus v-if="selectedEstado" class="w-5 h-5 text-white" @click.stop="clearSelection" />
                        <CirclePlus v-else class="w-5 h-5 text-white" />
                        {{ selectedEstado || 'Estado' }}
                    </button>

                    <!-- Pop-up do Estado -->
                    <div v-if="isOpen"
                        class="absolute left-0 top-full mt-2 w-40 md:w-48 bg-[#252422] font-medium rounded-md shadow-lg z-50">
                        <div class="border-2 rounded-md border-[#403D39]">
                            <div class="text-white px-2 border-b-2 border-[#403D39] font-medium">Estado</div>
                            <button v-for="(option, index) in estadoOptions" :key="option" @click="selectOption(option)"
                                aria-label="Select Option"
                                class="block w-full text-left px-4 py-2 text-white hover:bg-[#3D3A37] transition-all"
                                :class="[
                                    { 'bg-[#3D3A37]': selectedEstado === option },
                                    { 'border-b-2 border-[#403D39]': index !== estadoOptions.length - 1 }
                                ]">
                                {{ option }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-white text-left border-collapse">
                    <thead>
                        <tr class="border-b-2 border-text-gray text-text_gray border-[#69655F]">
                            <th class="px-4 py-2">ID Troca</th>
                            <th class="px-4 py-2">Unidade Curricular</th>
                            <th class="px-4 py-2">Turno Anterior</th>
                            <th class="px-4 py-2">Novo Turno</th>
                            <th class="px-4 py-2">Estado</th>
                            <th class="px-4 py-2">Data de Troca</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(troca, index) in filteredTrocas" :key="index"
                            class="border-b border-text-gray border-[#69655F] hover:bg-[#2A2927] transition-all">
                            <td class="px-4 py-3">{{ troca.idTroca }}</td>
                            <td class="px-4 py-3">{{ troca.uc }}</td>
                            <td class="px-4 py-3">{{ troca.turnoAnterior }}</td>
                            <td class="px-4 py-3">{{ troca.novoTurno }}</td>
                            <td class="px-4 py-3">
                                <estadoBadge :estado="troca.estado" />
                            </td>
                            <td class="px-4 py-3">{{ troca.data }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Paginação -->
        <div v-if="filteredTrocas.length !== 0" class="text-center text-white mt-auto pt-10 flex items-center justify-center gap-4 p-8">
            <button @click="currentPage--" :disabled="currentPage === 1" aria-label="Navegação"
                class="px-4 py-2 background_gray rounded-md">
                <SquareArrowLeft class="w-7 h-7" :class="currentPage === 1 ? 'text-white/50' : 'text-text_gray'" />
            </button>
            <span>Página {{ currentPage }} de {{ totalPages }}</span>
            <button @click="currentPage++" :disabled="currentPage === totalPages" aria-label="Navegação"
                class="px-4 py-2 background_gray rounded-md">
                <SquareArrowRight class="w-7 h-7"
                    :class="currentPage === totalPages ? 'text-white/50' : 'text-text_gray'" />
            </button>
        </div>
    </div>
</template>

<script>
import { SquareArrowLeft, SquareArrowRight, CirclePlus, CircleMinus } from 'lucide-vue-next';
import { ref, onMounted, computed, watch } from 'vue';
import { useAuthStore } from '@/stores/auth';
import axios from 'axios'
import estadoBadge from '../components/estadoBadge.vue';
export default {
    name: "HistoricoTrocas",
    components: {
        CirclePlus,
        CircleMinus,
        SquareArrowLeft,
        SquareArrowRight,
        estadoBadge
    },
    setup() {
        const trocas = ref([]);
        const searchQuery = ref("");
        const currentPage = ref(1);
        const isOpen = ref(false);
        const selectedEstado = ref('');
        const estadoOptions = ['Pendente', 'Deferido', 'Indeferido'];

        const userAuth = useAuthStore();
        const user = userAuth.user;

        function getStatus(status) {
            switch (status) {
                case 'pending':
                    return 'Pendente';
                case 'ok':
                    return 'Deferido';
                case 'rejected':
                    return 'Indeferido';
                default:
                    return 'Desconhecido';
            }
        }

        async function getTrocas() {
            try {
                const response = await axios.get('http://localhost:3000/shiftRequests?studentId=' + user.id);
                const data = response.data;

                if (data.length > 0) {
                    data.forEach(async troca => {
                        const toTurno = await axios.get(`http://localhost:3000/shifts/${troca.toShift}`);
                        const fromTurno = await axios.get(`http://localhost:3000/shifts/${troca.fromShift}`);

                        const toTurnoData = toTurno.data;
                        const ucResponse = await axios.get(`http://localhost:3000/courses/${toTurnoData.courseId}`);

                        const date = new Date(troca.date);
                        const formattedDate = date.toLocaleDateString('pt-PT');

                        trocas.value.push({
                            idTroca: troca.id,
                            uc: ucResponse.data.name,
                            turnoAnterior: fromTurno.data.name,
                            novoTurno: toTurnoData.name,
                            estado: getStatus(troca.response),
                            data: formattedDate
                        });
                    });
                } else {
                    totalPages.value = 1;
                }
            }
            catch (error) {
                console.error("Erro ao buscar as trocas" + error);
            }
        }

        const handleFilterClick = () => {
            if (selectedEstado.value) {
                selectedEstado.value = '';
            } else {
                isOpen.value = !isOpen.value;
            }
        };

        const selectOption = (option) => {
            selectedEstado.value = option;
            isOpen.value = false;
        };

        const clearSelection = () => {
            selectedEstado.value = '';
        };

        function removeAccents(str) {
            return str.normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .toLowerCase();
        }

        const filteredTrocas = computed(() => {
            let filtered = trocas.value;

            if (searchQuery.value) {
                const normalizedSearch = removeAccents(searchQuery.value);
                filtered = filtered.filter(troca =>
                    removeAccents(troca.uc).includes(normalizedSearch)
                );
            }

            if (selectedEstado.value) {
                filtered = filtered.filter(troca =>
                    troca.estado === selectedEstado.value
                );
            }

            const start = (currentPage.value - 1) * 9;
            const end = start + 9;
            return filtered.slice(start, end);
        });

        const totalPages = computed(() => {
            let filtered = trocas.value;

            if (searchQuery.value) {
                const normalizedSearch = removeAccents(searchQuery.value);
                filtered = filtered.filter(troca =>
                    removeAccents(troca.uc).includes(normalizedSearch)
                );
            }

            if (selectedEstado.value) {
                filtered = filtered.filter(troca =>
                    troca.estado === selectedEstado.value
                );
            }

            if (filtered.length === 0) {
                return 1;
            }

            return Math.ceil(filtered.length / 9);
        });

        watch([searchQuery, selectedEstado], () => {
            currentPage.value = 1;
        });

        onMounted(() => {
            getTrocas();
        });

        return {
            trocas,
            searchQuery,
            currentPage,
            filteredTrocas,
            totalPages,
            isOpen,
            selectedEstado,
            estadoOptions,
            handleFilterClick,
            selectOption,
            clearSelection
        }
    }
}
</script>