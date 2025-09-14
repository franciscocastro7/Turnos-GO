<template>
    <SucessToast v-if="showToast" />
    <div class="bg-background_gray h-full min-h-screen w-full flex flex-col font-poppins">
        <h1 v-if="trocas.length !== 0"
            class="px-20 xl:px-8 py-8 md:py-7 xl:py-10 text-sm md:text-lg font-poppins font-semibold text-white">
            <span class="font-poppins text-white/50">Gestão de Turnos /</span> Pedidos de Troca
        </h1>

        <div v-if="trocas.length === 0" class="flex-grow flex flex-col justify-center items-center">
            <span class="text-white text-lg sm:text-xl md:text-2xl font-poppins font-semibold text-center px-4 py-2">
                Não existem pedidos de troca registados.
            </span>
            <a href="/directors/home"
                class="underline text-xl text-[#D9D9D9] decoration-orange hover:text-orange transition-colors">
                Voltar
            </a>
        </div>


        <div v-if="trocas.length !== 0" class="p-8">
            <!-- Filtros -->
            <div class="flex items-center pb-4">
                <input type="text" placeholder="Filtrar por UC..." aria-label="Filtrar Por UC"
                    class="px-2 font-poppins bg-background_gray placeholder-text_gray text-text_gray rounded-md  w-1/2 lg:w-1/4 border-2 border-[#69655F] focus-visible: outline-none mr-4"
                    v-model="searchQuery" />
                <div class="relative">
                    <button @click="handleFilterClick" aria-label="Handle Filter"
                        class="flex items-center gap-4 bg-background_gray font-poppins px-2 rounded-md border-2 transition-all"
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
                                aria-label="Estado Option"
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

            <!-- Tabela in a flex-grow div -->
            <div class="flex-grow overflow-x-auto">
                <table class="w-full text-white text-left border-collapse">
                    <thead>
                        <tr class="border-b-2 border-text-gray text-text_gray border-[#69655F]">
                            <th class="px-4 py-2">ID Aluno</th>
                            <th class="px-4 py-2">Unidade Curricular</th>
                            <th class="px-4 py-2">Turno Anterior</th>
                            <th class="px-4 py-2">Novo Turno</th>
                            <th class="px-4 py-2">Estado</th>
                            <th class="px-4 py-2"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(troca, index) in filteredTrocas" :key="index"
                            class="border-b border-text-gray border-[#69655F] hover:bg-[#2A2927] transition-all">
                            <td class="px-4 py-3">{{ troca.idAluno }}</td>
                            <td class="px-4 py-3">{{ troca.uc }}</td>
                            <td class="px-4 py-3">{{ troca.turnoAnterior }}</td>
                            <td class="px-4 py-3">{{ troca.novoTurno }}</td>
                            <td class="px-4 py-3">
                                <estadoBadge :estado="troca.estado" />
                            </td>
                            <td class="px-4 py-3">
                                <button v-if="troca.estado === 'Pendente'" aria-label="Abrir PopUp"
                                    class="text-orange flex items-center text-center" @click="abrirPopup(troca)">
                                    <SquarePen class="w-7 h-7" />
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Paginação -->
        <div v-if="trocas.length !== 0"
            class="text-center text-white mt-auto pt-10 flex items-center justify-center gap-4 p-8">
            <button @click="currentPage--" :disabled="currentPage === 1" aria-label="Navigation"
                class="px-4 py-2 background_gray rounded-md">
                <SquareArrowLeft v-if="currentPage === 1" class="w-7 h-7 text-white/50" />
                <SquareArrowLeft v-else class="w-7 h-7 text-text_gray" />
            </button>
            <span>Página {{ currentPage }} de {{ totalPages }}</span>
            <button @click="currentPage++" :disabled="currentPage === totalPages" aria-label="Navigation"
                class="px-4 py-2 background_gray rounded-md">
                <SquareArrowRight v-if="currentPage === totalPages" class="w-7 h-7 text-white/50" />
                <SquareArrowRight v-else class="w-7 h-7 text-text_gray" />
            </button>
        </div>

        <EditarTrocaPopup :show="mostrarPopup" :aluno="alunoTroca" :troca="trocaAtual" :turnos="turnosDisponiveis"
            @aceitar="handleAceitar" @recusar="handleRecusar" @close="fecharPopup" />
    </div>
</template>

<script>
import { SquareArrowLeft, SquareArrowRight, CirclePlus, CircleMinus } from 'lucide-vue-next';
import estadoBadge from '../components/estadoBadge.vue';
import { SquarePen } from 'lucide-vue-next'
import { ref, computed, watch, onMounted } from 'vue';
import axios from 'axios';
import EditarTrocaPopup from '@/components/EditarTrocaPopup.vue';
import SucessToast from '@/components/SuccessToast.vue';

export default {
    name: "PedidosTrocas",
    components: {
        CirclePlus,
        CircleMinus,
        SquareArrowLeft,
        SquareArrowRight,
        estadoBadge,
        SquarePen,
        EditarTrocaPopup,
        SucessToast
    },
    setup() {
        const trocas = ref([]);
        const searchQuery = ref("");
        const currentPage = ref(1);
        const isOpen = ref(false);
        const selectedEstado = ref('');
        const estadoOptions = ['Pendente', 'Deferido', 'Indeferido'];
        const mostrarPopup = ref(false);
        const alunoTroca = ref({});
        const trocaAtual = ref({});
        const turnosDisponiveis = ref([]);
        const showToast = ref(false);

        async function getTrocas() {
            try {
                const response = await axios.get('http://localhost:3000/shiftRequests');
                if (response.status === 200) {
                    const data = response.data;

                    if (data.length === 0) {
                        return;
                    }

                    // Criar um array para armazenar as promessas
                    const trocasPromises = data.map(async (troca) => {
                        // Obter informações do aluno
                        const alunoResponse = await axios.get(`http://localhost:3000/students/${troca.studentId}`);
                        const idAluno = alunoResponse.data.email.split('@')[0];

                        // Obter informações da UC
                        const ucResponse = await axios.get(`http://localhost:3000/shifts/${troca.fromShift}`);
                        const ucId = ucResponse.data.courseId;
                        const ucResponse2 = await axios.get(`http://localhost:3000/courses/${ucId}`);
                        const uc = ucResponse2.data.name;
                        const ucAbrev = ucResponse2.data.abbreviation;

                        // Retornar o objeto formatado
                        return {
                            idAluno: idAluno,
                            uc: uc,
                            ucAbrev: ucAbrev,
                            turnoAnterior: troca.fromShift,
                            novoTurno: troca.toShift,
                            estado: getStatus(troca.response),
                            id: troca.id,
                            studentId: troca.studentId
                        };
                    });

                    // Aguardar todas as promessas e atribuir o resultado a trocas.value
                    trocas.value = await Promise.all(trocasPromises);
                }
            } catch (error) {
                console.error("Erro ao buscar as trocas:", error);
            }
        }

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

        const fecharPopup = async () => {
            mostrarPopup.value = false;
            await getTrocas();
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

        const removeAccents = (str) => {
            return str.normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .toLowerCase();
        };

        const filteredTrocas = computed(() => {
            let filtered = trocas.value;

            // Filtra por UC
            if (searchQuery.value) {
                filtered = filtered.filter(troca =>
                    removeAccents(troca.uc.toLowerCase()).includes(searchQuery.value.toLowerCase())
                );
            }

            // Filtra por Estado
            if (selectedEstado.value) {
                filtered = filtered.filter(troca =>
                    troca.estado === selectedEstado.value
                );
            }

            // Calcula a paginação
            const start = (currentPage.value - 1) * 9;
            const end = start + 9;
            return filtered.slice(start, end);
        });

        const totalPages = computed(() => {
            let filtered = trocas.value;

            // Aplica os mesmos filtros para calcular o total de páginas
            if (searchQuery.value) {
                filtered = filtered.filter(troca =>
                    removeAccents(troca.uc.toLowerCase()).includes(searchQuery.value.toLowerCase())
                );
            }

            if (selectedEstado.value) {
                filtered = filtered.filter(troca =>
                    troca.estado === selectedEstado.value
                );
            }

            return Math.ceil(filtered.length / 9) || 1;
        });

        // Reset página quando os filtros mudam
        watch([searchQuery, selectedEstado], () => {
            currentPage.value = 1;
        });

        onMounted(() => {
            getTrocas();
        });

        function traduzirDia(dia) {
            const mapaDias = {
                Monday: "2ªF",
                Tuesday: "3ªF",
                Wednesday: "4ªF",
                Thursday: "5ªF",
                Friday: "6ªF"
            };
            return mapaDias[dia] || dia;
        }

        function traduzirDiaBox(dia) {
            const mapaDias = {
                Monday: "2ª Feira",
                Tuesday: "3ª Feira",
                Wednesday: "4ª Feira",
                Thursday: "5ª Feira",
                Friday: "6ª Feira"
            };
            return mapaDias[dia] || dia;
        }

        const handleAceitar = async () => {
            showToast.value = true;
            setTimeout(() => {
                showToast.value = false;
            }, 5000);
        }

        const handleRecusar = async () => {
            showToast.value = true;
            setTimeout(() => {
                showToast.value = false;
            }, 5000);
        }

        async function abrirPopup(troca) {
            try {
                // Obter informações do aluno
                const alunoResponse = await axios.get(`http://localhost:3000/students/${troca.studentId}`);
                const alunoData = alunoResponse.data;

                // Obter informações do turno atual
                const turnoAtualResponse = await axios.get(`http://localhost:3000/shifts/${troca.turnoAnterior}`);
                const turnoAtual = turnoAtualResponse.data;

                // Obter informações do turno desejado
                const turnoDesejadoResponse = await axios.get(`http://localhost:3000/shifts/${troca.novoTurno}`);
                const turnoDesejado = turnoDesejadoResponse.data;

                // Obter informações do pedido de troca
                const pedidoResponse = await axios.get(`http://localhost:3000/shiftRequests/${troca.id}`);
                const pedido = pedidoResponse.data;

                // Obter turnos alternativos para sugestão
                const turnosResponse = await axios.get(`http://localhost:3000/shifts?day=${turnoDesejado.day}&from=${turnoDesejado.from}&to=${turnoDesejado.to}&courseId=${turnoDesejado.courseId}`);
                const turnosData = turnosResponse.data; // Excluir o próprio turno desejado
                const turnos = turnosData.filter(turno => {
                    // se o aluno tiver estatuto, passo todos os turnos
                    if (alunoData.specialStatus !== "N/A") {
                        return true;
                    }
                    // Caso contrário, só passo os turnos que têm espaço
                    return turno.totalStudentsRegistered < turno.studentLimit;
                })

                // Obter informações do professor do turno desejado
                const docenteResponse = await axios.get(`http://localhost:3000/teachers/${turnoDesejado.teacherId}`);
                const docente = docenteResponse.data;

                // Obter informações do professor da sala
                const salaResponse = await axios.get(`http://localhost:3000/classrooms/${turnoDesejado.classroomId}`);
                const sala = salaResponse.data.name;


                // Formatar os dados conforme esperado pelo componente EditarTrocaPopup
                alunoTroca.value = {
                    nome: alunoData.name,
                    email: alunoData.email,
                    estatuto: alunoData.specialStatus || "N/A",
                    numero: alunoData.email.split('@')[0].toUpperCase(),
                    ano: alunoData.year,
                    telemovel: alunoData.phone
                };

                trocaAtual.value = {
                    id: troca.id,
                    uc: troca.uc,
                    ucAbrev: troca.ucAbrev,
                    motivo: pedido.reason || "Não especificado",
                    turnoAtual: turnoAtual.name,
                    horarioAtual: `${traduzirDia(turnoAtual.day)} ${turnoAtual.from}h00 - ${turnoAtual.to}h00`,
                    turnoDesejado: turnoDesejado.name,
                    horarioDesejado: `${traduzirDia(turnoDesejado.day)} ${turnoDesejado.from}h00 - ${turnoDesejado.to}h00`,
                    docente: docente.name,
                    sala: sala,
                    ocupacao: `${turnoDesejado.totalStudentsRegistered} / ${turnoDesejado.studentLimit}`,
                    percentagemOcupacao: Math.round(turnoDesejado.totalStudentsRegistered / turnoDesejado.studentLimit * 100),
                };

                const turnosDetalhados = await Promise.all(turnos.map(async (turno) => {
                    // Obter informações do professor
                    const professorResponse = await axios.get(`http://localhost:3000/teachers/${turno.teacherId}`);
                    const professor = professorResponse.data;

                    // Obter informações da sala
                    const salaResponse = await axios.get(`http://localhost:3000/classrooms/${turno.classroomId}`);
                    const sala = salaResponse.data.name;

                    return {
                        ...turno,
                        docente: professor.name,
                        salaId: sala,
                        ocupacao: `${turno.totalStudentsRegistered} / ${turno.studentLimit}`,
                        percentagemOcupacao: Math.round(turno.totalStudentsRegistered / turno.studentLimit * 100),
                        dia: traduzirDiaBox(turno.day),
                    };
                }));

                turnosDisponiveis.value = turnosDetalhados;
                mostrarPopup.value = true;

            } catch (error) {
                console.error("Erro ao abrir popup de edição de troca:", error);
                showToast.value = true;
                setTimeout(() => {
                    showToast.value = false;
                }, 5000);
            }
        }

        return {
            trocas,
            searchQuery,
            currentPage,
            isOpen,
            selectedEstado,
            estadoOptions,
            handleFilterClick,
            selectOption,
            clearSelection,
            filteredTrocas,
            totalPages,
            mostrarPopup,
            alunoTroca,
            trocaAtual,
            turnosDisponiveis,
            abrirPopup,
            fecharPopup,
            showToast,
            handleAceitar,
            handleRecusar,
        }
    }
}
</script>