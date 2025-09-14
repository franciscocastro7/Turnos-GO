<template>
    <div class="bg-background_gray min-h-screen w-full text-white font-poppins pb-5 xl:pb-0">
        <h1 class="px-20 xl:px-8 py-8 md:py-7 xl:py-10 text-sm md:text-lg font-poppins font-semibold text-white">
            <span class="text-white/50">Gestão de Turnos /</span> <a class="underline hover:text-text_gray text-white/85" href="/directors/alocar-listaAlunos">Alocar Aluno</a> / {{ aluno?.email.split('@')[0] || 'Carregando...' }}
        </h1>

        <div class="px-4 sm:px-8 md:px-16">
            <h1 class="text-3xl md:text-4xl lg:text-5xl font-semibold mb-3">
                Alocar Aluno <span class="text-orange"> {{ aluno?.email.split('@')[0] || 'Carregando...' }} </span>
            </h1>
    
            <div class="border-2 border-[#69655F] rounded-lg py-2 px-3 md:px-4 pt-2 flex flex-col gap-2 mb-4">
                <span class="font-semibold text-xl md:text-2xl">Informação do Aluno</span>
                <div class="flex flex-col sm:flex-row flex-wrap justify-start gap-4 sm:gap-8 md:gap-12 lg:gap-20 text-base md:text-lg lg:text-xl">
                    <p class="text-white/50 font-medium">NOME <span class="text-white">{{ aluno?.name }}</span></p>
                    <p class="text-white/50 font-medium">EMAIL <span class="text-white">{{ aluno?.email }}</span></p>
                    <p class="text-white/50 font-medium">TLM <span class="text-white">{{ aluno?.phone }}</span></p>
                </div>
                <div class="flex flex-col md:flex-row flex-wrap justify-between items-start text-base md:text-lg lg:text-xl w-full">
                    <div class="flex flex-col sm:flex-row flex-wrap gap-4 sm:gap-8 md:gap-16 xl:gap-36 pt-1 mb-3 md:mb-0">
                        <p class="text-white/50 font-medium">Nº ALUNO <span class="text-white">{{ aluno?.email.split('@')[0] }}</span></p>
                        <p class="text-white/50 font-medium">ESTATUTO <span class="text-white">{{ aluno?.specialStatus }}</span></p>
                        <p class="text-white/50 font-medium">ANO <span class="text-white">{{ aluno?.year }}</span></p>
                        <p class="text-white/50 font-medium">Nº CADEIRAS INSCRITO <span class="text-white">{{ aluno?.enrolled.length }}</span></p>
                    </div>
                    <div class="mt-2 md:mt-0">
                        <button 
                            @click="publicarHorario"
                            :disabled="conflitosDetectados.length > 0"
                            :class="[
                                'px-4 md:px-6 font-semibold py-1 rounded-2xl transition',
                                conflitosDetectados.length > 0 ? 'bg-[#69655F] text-white opacity-70 cursor-not-allowed' : 'bg-orange text-white hover:bg-orange/90 hover:scale-105'
                            ]">
                            Publicar Horário
                        </button>
                    </div>
                </div>
            </div>
    
            <div class="flex flex-col xl:flex-row gap-4 lg:gap-8">
                <div class="flex flex-col gap-3 w-full xl:w-72 border-2 border-[#69655F] rounded-lg py-2 px-2 text-base md:text-lg lg:text-xl overflow-y-auto max-h-[240px] lg:max-h-[560px]">
                    <div class="flex flex-row flex-wrap lg:flex-col gap-2">
                        <button 
                            @click="selectCourse(curso)" 
                            v-for="curso in courses" 
                            :key="curso.id" 
                            :class="[
                                'bg-orange border-2 min-h-16 sm:min-h-20 w-[48%] sm:w-[31%] md:w-[23%] lg:w-full border-[#F38C64] font-semibold py-2 rounded-2xl flex items-center justify-center',
                                selectedCourse?.id === curso.id ? 'bg-opacity-60' : 'bg-opacity-10'
                            ]">
                            {{curso.abbreviation}}
                        </button>
                    </div>
                </div>
    
                <!-- Main Content -->
                <div class="flex-1 border border-[#69655F] rounded-md p-3 md:p-6">
                    <!-- Turnos Teóricos -->
                    <div class="flex justify-between items-center">
                        <h2 class="font-semibold text-xl md:text-2xl mb-2">Turnos Teóricos disponíveis</h2>
                    </div>
                    <div class="w-full sm:w-2/3 md:w-1/2 border border-white rounded-md overflow-hidden mb-4 md:mb-6 text-base md:text-lg lg:text-xl font-medium font-poppins">
                        <div class="flex flex-col h-[10vh] overflow-y-auto divide-y divide-white/30">
                            <label v-for="turno in turnosT" :key="turno.id" class="flex items-center border-b border-[#69655F] gap-2 px-2 md:px-4 py-2">
                                <input 
                                type="radio" 
                                name="teorico" 
                                class="accent-orange" 
                                :value="turno" 
                                v-model="selectedTeorico" 
                                />
                                <span class="text-sm sm:text-base md:text-lg lg:text-xl">{{turno.name}} {{`(${getDay(turno.day)} ${turno.from}h00 - ${turno.to}h00)`}}</span>
                            </label>
                        </div>
                    </div>
    
                    <!-- Turnos Práticos -->
                    <div class="flex flex-col xl:flex-row justify-between items-start lg:items-end gap-4 lg:gap-6">
                        <div class="w-full xl:w-1/2">
                            <h2 class="font-semibold text-xl md:text-2xl mb-2">Turnos Práticos disponíveis</h2>
                            <div class="border border-white rounded-md overflow-hidden text-base md:text-lg lg:text-xl font-medium font-poppins">
                                <div class="flex flex-col h-[20vh] lg:h-[25vh] overflow-y-auto divide-y divide-white/30">
                                    <label v-for="turno in turnosP" :key="turno.id" class="flex border-b border border-white/30 items-center gap-2 px-2 md:px-4 py-2">
                                        <input 
                                        type="radio" 
                                        name="pratico" 
                                        class="accent-orange" 
                                        :value="turno" 
                                        v-model="selectedPratico" 
                                        />
                                        <span class="text-sm sm:text-base md:text-lg lg:text-xl">{{turno.name}} {{`(${getDay(turno.day)} ${turno.from}h00 - ${turno.to}h00)`}} - <span :class="getOcupacaoColor(Math.ceil(turno.totalStudentsRegistered / turno.studentLimit * 100))">{{Math.ceil(turno.totalStudentsRegistered / turno.studentLimit * 100) + '%'}}</span></span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="w-full xl:max-w-lg text-white" v-if="conflitosDetectados.length > 0">
                            <div class="bg-[#403D39] bg-opacity-40 p-3 md:p-4 rounded-md border-l-[6px] md:border-l-[10px] border-red-700">
                                <h3 class="text-red-700 inline-flex items-center gap-2 text-lg md:text-xl font-bold mb-1">
                                    <CircleAlert class="w-6 h-6 md:w-8 md:h-8 text-red-700" /> Conflito de horário detectado
                                </h3>
                                <p class="mb-3 md:mb-6 text-base md:text-lg font-medium">
                                    Foi detectada um conflito no horário do aluno devido ao(s) seguinte turno(s) selecionado(s):
                                </p>
                                <ul class="list-disc list-inside text-base md:text-lg lg:text-xl mb-4 space-y-1 marker:text-red-700 text-white">
                                    <li v-for="(conflito, index) in conflitosDetectados" :key="index" class="text-sm sm:text-base md:text-lg lg:text-xl">
                                        {{ conflito.turno.name }} = {{ getDay(conflito.turno.day) }} {{ conflito.turno.from }}h00 - {{ conflito.turno.to }}h00 ({{ conflito.curso }})
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
    
                    <!-- Botões -->
                    <div class="flex justify-center sm:justify-end gap-3 md:gap-4 mt-6 md:mt-8">
                        <button
                            @click="cancelar"
                            class="font-poppins font-bold px-6 md:px-10 py-2 border border-orange text-white text-base md:text-lg lg:text-xl rounded-3xl hover:scale-105 hover:shadow-lg transition">Cancelar</button>
                        <button
                            @click="efetuarAlocacao"
                            class="font-poppins font-bold px-6 md:px-8 py-2 bg-orange text-base md:text-lg lg:text-xl text-white rounded-3xl transition hover:bg-orange/80 hover:scale-105 hover:shadow-lg">
                            Efetuar Alocação
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Notificação de Sucesso -->
        <div v-if="showSuccess" class="fixed top-4 right-4 bg-green-600 text-white px-4 md:px-6 py-2 md:py-3 rounded-lg shadow-lg flex items-center gap-2 md:gap-3 text-sm md:text-base">
            <CircleCheckBig class="w-5 h-5 md:w-6 md:h-6" />
            <span>{{ successMessage }}</span>
        </div>
    </div>
</template>

<script>
import { CircleAlert, CircleCheckBig } from 'lucide-vue-next';
import { ref, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';
import axios from 'axios';
import { useRouter } from 'vue-router';

export default {
    name: 'AlocarListaAlunos',
    components: {
        CircleAlert,
        CircleCheckBig,
    },
    setup() {
        const route = useRoute();
        const idAluno = route.params.id;
        const aluno = ref(null);
        const courses = ref([]);
        const selectedCourse = ref(null);
        const turnos = ref([]);
        const turnosP = ref([]);
        const turnosT = ref([]);
        const selectedPratico = ref(null);
        const selectedTeorico = ref(null);
        const conflitosDetectados = ref([]);
        const showSuccess = ref(false);
        const successMessage = ref('');
        
        const alunoSelecoes = ref({});

        const alocacoesExistentes = ref([]);

        const turnosARemover = ref(new Set());
        const turnosAAdicionar = ref(new Set());

        const router = useRouter();

        async function fetchAluno() {
            try {
                const response = await axios.get(`http://localhost:3000/students/${idAluno}`);
                aluno.value = response.data;
                
                if (aluno.value?.enrolled?.length > 0) {
                    await fetchCourses(aluno.value.enrolled);
                }
            } catch (error) {
                console.error('Erro ao buscar aluno:', error);
            }
        }

        async function fetchCourses(enrolled) {
            try {
                const coursePromises = enrolled.map(courseId => 
                    axios.get(`http://localhost:3000/courses/${courseId}`)
                );
                
                const responses = await Promise.all(coursePromises);
                courses.value = responses.map(response => response.data);
                
                if (courses.value.length > 0) {
                    await fetchTurnos();
                    await fetchAlocacoes();
                    
                    // Selecionar o primeiro curso após carregar todos os dados
                    if (selectedCourse.value === null) {
                        selectCourse(courses.value[0]);
                    }
                }
            } catch (error) {
                console.error('Erro ao buscar cursos:', error);
            }
        }

        async function fetchTurnos() {
            try {
                turnos.value = [];
                
                const turnosPromises = courses.value.map(course => 
                    axios.get(`http://localhost:3000/shifts?courseId=${course.id}`)
                );
                
                const responses = await Promise.all(turnosPromises);
                responses.forEach(response => {
                    turnos.value = [...turnos.value, ...response.data];
                });
            } catch (error) {
                console.error('Erro ao buscar turnos:', error);
            }
        }

        async function fetchAlocacoes() {
            try {
                const response = await axios.get(`http://localhost:3000/allocations?studentId=${idAluno}`);
                alocacoesExistentes.value = response.data;
                
                // Inicializar o objeto de seleções do aluno
                courses.value.forEach(course => {
                    if (!alunoSelecoes.value[course.id]) {
                        alunoSelecoes.value[course.id] = { teorico: null, pratico: null };
                    }
                });
                
                // Preencher seleções existentes
                alocacoesExistentes.value.forEach(alocacao => {
                    const turno = turnos.value.find(t => t.id === alocacao.shiftId);
                    if (turno) {
                        const courseId = turno.courseId;
                        if (!alunoSelecoes.value[courseId]) {
                            alunoSelecoes.value[courseId] = { teorico: null, pratico: null };
                        }
                        
                        if (turno.type === 'T') {
                            alunoSelecoes.value[courseId].teorico = turno;
                        } else if (turno.type === 'PL') {
                            alunoSelecoes.value[courseId].pratico = turno;
                        }
                    }
                });
                
                // Atualizar seleção atual se um curso já estiver selecionado
                if (selectedCourse.value) {
                    updateSelecaoAtual();
                }
                
                // Verificar conflitos após carregar alocações
                await verificarConflitos();
                
            } catch (error) {
                console.error('Erro ao buscar alocações do aluno:', error);
            }
        }

        function selectCourse(curso) {
            selectedCourse.value = curso;
            getTurnosByCourse(curso.id);
            updateSelecaoAtual();
        }

        function updateSelecaoAtual() {
            if (selectedCourse.value && alunoSelecoes.value[selectedCourse.value.id]) {
                selectedTeorico.value = alunoSelecoes.value[selectedCourse.value.id].teorico;
                selectedPratico.value = alunoSelecoes.value[selectedCourse.value.id].pratico;
            } else {
                selectedTeorico.value = null;
                selectedPratico.value = null;
            }
        }

        function getTurnosByCourse(courseId) {
            if (!courseId || !turnos.value.length) return;
            
            turnosP.value = turnos.value.filter(turno => 
                turno.courseId === (courseId) && turno.type === 'PL'
            );
            
            turnosT.value = turnos.value.filter(turno => 
                turno.courseId === (courseId) && turno.type === 'T'
            );
        }

        async function verificarConflitos() {
            try {
                const conflitosAlunoResponse = await axios.get(`http://localhost:3000/conflicts?studentId=${idAluno}`);
                const conflitosAluno = conflitosAlunoResponse.data[0]?.courseIDs || [];

                const turnosCourse = [];

                for (const courseId of conflitosAluno) {
                    const turnosResponse = await axios.get(`http://localhost:3000/shifts?courseId=${courseId}`);
                    const turnos = turnosResponse.data;

                    for (const turno of turnos) {
                        const alocacaoResponse = await axios.get(`http://localhost:3000/allocations?studentId=${idAluno}&shiftId=${turno.id}`);
                        if (alocacaoResponse.data.length > 0) {
                            turnosCourse.push(turno);
                        }
                    }
                }

                const conflitos = [];

                for (let i = 0; i < turnosCourse.length; i++) {
                    for (let j = i + 1; j < turnosCourse.length; j++) {
                        const t1 = turnosCourse[i];
                        const t2 = turnosCourse[j];

                        if (t1.day === t2.day && t1.from < t2.to && t1.to > t2.from) {
                            const c1 = courses.value.find(c => (c.id) === t1.courseId);
                            const c2 = courses.value.find(c => (c.id) === t2.courseId);

                            conflitos.push({
                                turno: t1,
                                curso: c1?.abbreviation || t1.courseId
                            });
                            conflitos.push({
                                turno: t2,
                                curso: c2?.abbreviation || t2.courseId
                            });
                        }
                    }
                }

                conflitosDetectados.value = conflitos;
            } catch (error) {
                console.error("Erro ao buscar conflitos:", error);
            }
        }

        async function efetuarAlocacao() {
            if (selectedCourse.value) {
                const courseId = selectedCourse.value.id;

                if (!alunoSelecoes.value[courseId]) {
                    alunoSelecoes.value[courseId] = { teorico: null, pratico: null };
                }

                alunoSelecoes.value[courseId].teorico = selectedTeorico.value;
                alunoSelecoes.value[courseId].pratico = selectedPratico.value;

                try {
                    await atualizarAlocacoes(courseId);
                    
                    await verificarConflitos();
                    
                    showSuccessMessage(`Alocação para ${selectedCourse.value.abbreviation} efetuada com sucesso!`);
                    
                } catch (error) {
                    console.error("Erro ao efetuar alocação:", error);
                }
            }
        }
        
        async function atualizarAlocacoes(courseId) {
            const alocacoesDoCurso = alocacoesExistentes.value.filter(alocacao => {
                const turno = turnos.value.find(t => t.id === alocacao.shiftId);
                return turno && turno.courseId === courseId;
            });
            
            // Track shifts to remove/add
            if (selectedTeorico.value) {
                const alocacaoTeorica = alocacoesDoCurso.find(alocacao => {
                    const turno = turnos.value.find(t => t.id === alocacao.shiftId);
                    return turno && turno.type === 'T';
                });
                
                if (alocacaoTeorica) {
                    // Se está trocando de turno, registrar ambos
                    if (alocacaoTeorica.shiftId !== selectedTeorico.value.id) {
                        turnosARemover.value.add(alocacaoTeorica.shiftId);
                        turnosAAdicionar.value.add(selectedTeorico.value.id);
                    }
                    
                    await axios.patch(`http://localhost:3000/allocations/${alocacaoTeorica.id}`, {
                        shiftId: `${selectedTeorico.value.id}`
                    });
                } else {
                    // Novo turno
                    turnosAAdicionar.value.add(selectedTeorico.value.id);
                    
                    await axios.post(`http://localhost:3000/allocations`, {
                        studentId: `${idAluno}`,
                        shiftId: `${selectedTeorico.value.id}`
                    });
                }
            }
            
            if (selectedPratico.value) {
                const alocacaoPratica = alocacoesDoCurso.find(alocacao => {
                    const turno = turnos.value.find(t => t.id === alocacao.shiftId);
                    return turno && turno.type === 'PL';
                });
                
                if (alocacaoPratica) {
                    // Se está trocando de turno, registrar ambos
                    if (alocacaoPratica.shiftId !== selectedPratico.value.id) {
                        turnosARemover.value.add(alocacaoPratica.shiftId);
                        turnosAAdicionar.value.add(selectedPratico.value.id);
                    }
                    
                    await axios.patch(`http://localhost:3000/allocations/${alocacaoPratica.id}`, {
                        shiftId: `${selectedPratico.value.id}`
                    });
                } else {
                    // Novo turno
                    turnosAAdicionar.value.add(selectedPratico.value.id);
                    
                    await axios.post(`http://localhost:3000/allocations`, {
                        studentId: `${idAluno}`,
                        shiftId: `${selectedPratico.value.id}`
                    });
                }
            }
            if(turnosARemover.value.size > 0) {
                for (const shiftId of turnosARemover.value) {
                        const shift = turnos.value.find(t => t.id === shiftId);
                        if (shift) {
                            await axios.patch(`http://localhost:3000/shifts/${shiftId}`, {
                                totalStudentsRegistered: shift.totalStudentsRegistered - 1
                            });
                        }
                    }
                turnosARemover.value.clear();
                
            }
            if(turnosAAdicionar.value.size > 0) {
                for (const shiftId of turnosAAdicionar.value) {
                    const shift = turnos.value.find(t => t.id === shiftId);
                    if (shift) {
                        await axios.patch(`http://localhost:3000/shifts/${shiftId}`, {
                            totalStudentsRegistered: shift.totalStudentsRegistered + 1
                        });
                    }
                }
                turnosAAdicionar.value.clear();
            }
        }
        
        async function publicarHorario() {
            try {
                if (conflitosDetectados.value.length > 0) {
                    return;
                }
                
                const response = await axios.get(`http://localhost:3000/conflicts?studentId=${idAluno}`);
                await axios.delete(`http://localhost:3000/conflicts/${response.data[0].id}`);
            
                await axios.post(`http://localhost:3000/notifications`, {
                    userId: aluno.value.email,
                    type: "Publicação de Horário",
                    date: new Date().toISOString(),
                    title: "Publicação de Horário",
                    message: "O seu horário foi finalmente publicado, dê uma vista de olhos!",
                    read: 'false'
                });

                showSuccessMessage("Horário publicado com sucesso!");
                router.push('/directors/alocar-listaAlunos');
                
            } catch (error) {
                console.error("Erro ao publicar horário:", error);
                showErrorMessage("Erro ao publicar horário. Tente novamente.");
            }
        }
        
        function showSuccessMessage(message) {
            successMessage.value = message;
            showSuccess.value = true;
            
            // Esconder a mensagem após 3 segundos
            setTimeout(() => {
                showSuccess.value = false;
            }, 3000);
        }

        function cancelar () {
            router.push('/directors/alocar-listaAlunos');
        }

        function getOcupacaoColor(ocupacao) {
            if (ocupacao >= 90) return "text-red-600 font-semibold";
            if (ocupacao >= 70) return "text-orange font-semibold";
            if (ocupacao >= 50) return "text-yellow-400 font-semibold";
            return "text-lime-500 font-semibold";
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

        // Watch para atualizar as seleções quando os turnos mudam
        watch([selectedTeorico, selectedPratico], () => {
            if (selectedCourse.value) {
                const courseId = selectedCourse.value.id;
                if (!alunoSelecoes.value[courseId]) {
                    alunoSelecoes.value[courseId] = { teorico: null, pratico: null };
                }
                // Atualizar temporariamente (será confirmado no efetuarAlocacao)
                if (selectedTeorico.value) {
                    alunoSelecoes.value[courseId].teorico = selectedTeorico.value;
                }
                if (selectedPratico.value) {
                    alunoSelecoes.value[courseId].pratico = selectedPratico.value;
                }
            }
        });

        onMounted(async () => {
            await fetchAluno();
        });

        return {
            idAluno,
            aluno,
            courses,
            turnos,
            turnosP,
            turnosT,
            selectedTeorico,
            selectedPratico,
            selectedCourse,
            conflitosDetectados,
            showSuccess,
            successMessage,
            getOcupacaoColor,
            getDay,
            selectCourse,
            efetuarAlocacao,
            publicarHorario,
            cancelar
        };
    }
}
</script>