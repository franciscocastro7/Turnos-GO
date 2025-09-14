<template>
    <div class="bg-background_gray min-h-screen w-full flex flex-col font-poppins">
        <h1 class="px-20 xl:px-8 py-8 sm:py-7 xl:py-10 text-sm md:text-lg font-poppins font-semibold text-white pb-6">
            <span class="text-white/50">Gestão de Turnos /</span> Consultar Turnos
        </h1>

        <div class="p-8">
            <!-- Filtros -->
            <div class="flex items-center pb-4">
                <input type="text" placeholder="Filtrar por UC..." aria-label="Filtrar Por UC"
                    class="px-2 bg-background_gray placeholder-text_gray text-text_gray rounded-md w-1/2 lg:w-1/4 border-2 border-[#69655F] focus-visible: outline-none mr-4"
                    v-model="searchQuery" />
                <div class="relative">
                    <button @click="handleFilterClick" aria-label="Handle Filter"
                        class="flex items-center gap-4 bg-background_gray px-2 rounded-md border-2 transition-all"
                        :class="[
                            selectedTipoTurno
                                ? 'border-orange text-white border-solid'
                                : 'border-[#69655F] text-white/50 border-dashed hover:border-orange hover:text-white hover:border-solid'
                        ]">
                        <CircleMinus v-if="selectedTipoTurno" class="w-5 h-5 text-white" @click.stop="clearSelection" />
                        <CirclePlus v-else class="w-5 h-5 text-white" />
                        {{ selectedTipoTurno || 'Tipo Turno' }}
                    </button>

                    <!-- Pop-up do Tipo Turno -->
                    <div v-if="isOpen"
                        class="absolute left-0 top-full mt-2 w-40 md:w-48 bg-[#252422] font-medium rounded-md shadow-lg z-50">
                        <div class="border-2 rounded-md border-[#403D39]">
                            <div class="text-white px-2 border-b-2 border-[#403D39] font-medium">Tipo Turno</div>
                            <button v-for="(option, index) in tipoTurnoOptions" :key="option.label"
                                aria-label="Tipo de Turno" @click="selectOption(option.label)"
                                class="block w-full text-left px-4 py-2 text-white hover:bg-[#3D3A37] transition-all"
                                :class="[
                                    { 'bg-[#3D3A37]': selectedTipoTurno === option.label },
                                    { 'border-b-2 border-[#403D39]': index !== tipoTurnoOptions.length - 1 }
                                ]">
                                {{ option.label }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabela -->
            <div class="overflow-x-auto">
                <table class="w-full text-white text-left border-collapse">
                    <thead>
                        <tr class="border-b-2 border-text-gray text-text_gray border-[#69655F]">
                            <th class="px-4 py-2">Unidade Curricular</th>
                            <th class="px-4 py-2">Turno</th>
                            <th class="px-4 py-2">Horário</th>
                            <th class="px-4 py-2">Ocupação</th>
                            <th class="px-4 py-2">Sala</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(turno, index) in filteredTurnos" :key="index"
                            class="border-b border-text-gray border-[#69655F] hover:bg-[#2A2927] transition-all">
                            <td class="px-4 py-3">{{ turno.unidade }}</td>
                            <td class="px-4 py-3">{{ turno.turno }}</td>
                            <td class="px-4 py-3">{{ turno.horario }}</td>
                            <td class="px-4 py-3">
                                {{ turno.ocupacao.split(' ')[0] }}
                                <span :class="getOcupacaoColor(turno.ocupacao)">
                                    {{ turno.ocupacao.match(/\(\d+%\)/)[0] }}
                                </span>
                            </td>
                            <td class="px-4 py-3">{{ turno.sala }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Paginação -->
        <div class="text-center text-white mt-auto pt-10 flex items-center justify-center gap-4 p-8">
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
import { CirclePlus, CircleMinus, SquareArrowLeft, SquareArrowRight } from 'lucide-vue-next';
import axios from 'axios';
import { ref, computed, watch, onMounted } from 'vue';

export default {
    name: "ConsultarTurnos",
    components: {
        CirclePlus,
        CircleMinus,
        SquareArrowLeft,
        SquareArrowRight
    },
    setup() {
        const searchQuery = ref("");
        const currentPage = ref(1);
        const turnos = ref([]);
        const isOpen = ref(false);
        const selectedTipoTurno = ref('');
        const tipoTurnoOptions = [
            { label: 'Teórico', code: 'T' },
            { label: 'Prático-Laboratorial', code: 'PL' },
            { label: 'Teórico-Prático', code: 'TP' }
        ];

        const handleFilterClick = () => {
            if (selectedTipoTurno.value) {
                selectedTipoTurno.value = '';
            } else {
                isOpen.value = !isOpen.value;
            }
        };

        const selectOption = (option) => {
            selectedTipoTurno.value = option;
            isOpen.value = false;
        };

        const clearSelection = () => {
            selectedTipoTurno.value = '';
        };

        const removeAccents = (str) => {
            return str.normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .toLowerCase();
        };

        const getTurnoType = (turnoName) => {
            if (turnoName.startsWith('T')) return 'Teórico';
            if (turnoName.startsWith('PL')) return 'Prático-Laboratorial';
            if (turnoName.startsWith('TP')) return 'Teórico-Prático';
            return '';
        };

        const getOcupacaoColor = (ocupacao) => {
            const percentage = parseInt(ocupacao.match(/\d+(?=%)/)[0]);
            if (percentage >= 90) return "text-red-600 font-semibold";
            if (percentage >= 70) return "text-orange font-semibold";
            if (percentage >= 50) return "text-yellow-400 font-semibold";
            return "text-lime-500 font-semibold";
        };

        const filteredTurnos = computed(() => {
            let filtered = turnos.value;

            // Filtra por UC
            if (searchQuery.value) {
                filtered = filtered.filter(turno =>
                    removeAccents(turno.unidade.toLowerCase()).includes(searchQuery.value.toLowerCase())
                );
            }

            // Filtra por Tipo de Turno
            if (selectedTipoTurno.value) {
                filtered = filtered.filter(turno => {
                    return getTurnoType(turno.turno) === selectedTipoTurno.value;
                });
            }

            // Paginação
            const start = (currentPage.value - 1) * 9;
            return filtered.slice(start, start + 9);
        });

        const totalPages = computed(() => {
            let filtered = turnos.value;

            // Aplica os mesmos filtros para calcular o total de páginas
            if (searchQuery.value) {
                filtered = filtered.filter(turno =>
                    removeAccents(turno.unidade.toLowerCase()).includes(searchQuery.value.toLowerCase())
                );
            }

            if (selectedTipoTurno.value) {
                filtered = filtered.filter(turno => {
                    return getTurnoType(turno.turno) === selectedTipoTurno.value;
                });
            }

            return Math.ceil(filtered.length / 9) || 1;
        });

        const fetchTurnos = async () => {
            try {
                const response = await axios.get('http://localhost:3000/shifts');
                const data = await Promise.all(response.data.map(async (turno) => {
                    const dayMap = {
                        Monday: '2ª F',
                        Tuesday: '3ª F',
                        Wednesday: '4ª F',
                        Thursday: '5ª F',
                        Friday: '6ª F'
                    };
                    const diaSemana = dayMap[turno.day] || '';
                    const horario = `${diaSemana} - ${turno.from}h - ${turno.to}h`;
                    const ocupacao = `${turno.totalStudentsRegistered}/${turno.studentLimit} (${Math.round((turno.totalStudentsRegistered / turno.studentLimit) * 100)}%)`;

                    const [courseRes, roomRes] = await Promise.all([
                        axios.get(`http://localhost:3000/courses/${turno.courseId}`),
                        axios.get(`http://localhost:3000/classrooms/${turno.classroomId}`)
                    ]);

                    return {
                        unidade: courseRes.data.name,
                        turno: turno.name,
                        horario,
                        ocupacao,
                        sala: roomRes.data.name
                    };
                }));

                turnos.value = data;
            } catch (error) {
                console.error("Erro ao buscar turnos:", error);
            }
        };

        // Reset página quando os filtros mudam
        watch([searchQuery, selectedTipoTurno], () => {
            currentPage.value = 1;
        });

        onMounted(() => {
            fetchTurnos();
        });

        return {
            searchQuery,
            currentPage,
            turnos,
            isOpen,
            selectedTipoTurno,
            tipoTurnoOptions,
            handleFilterClick,
            selectOption,
            clearSelection,
            getOcupacaoColor,
            filteredTurnos,
            totalPages
        };
    }
};
</script>