<template>
    <div v-if="show"
        class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50 px-2 overflow-y-auto">
        <div
            class="bg-[#252422] rounded-2xl py-6 sm:py-8 w-full max-w-[95vw] sm:max-w-5xl relative text-white font-poppins max-h-[95vh] overflow-y-auto animate-fade-in">

            <!-- Cabeçalho -->
            <div class="mb-6 px-4 sm:px-10">
                <p class="text-[#69655F] text-sm sm:text-lg font-semibold mb-3">
                    Gestão de Turnos / Consultar Turnos /
                    <span class="text-white">{{ course.abbreviation }}</span> /
                    <span class="text-[#EB5E28]">{{ turno.turno }}</span>
                </p>
                <h2 class="text-2xl sm:text-3xl font-bold mb-1">Turno: {{ turno.turno }}</h2>
                <p v-if="turno.totalStudents < turno.limiteAlunos" class="text-lime-500 font-semibold">Com Capacidade</p>
                <p v-else class="text-red-500 font-semibold">Capacidade Máxima</p>

            </div>

            <!-- Conteúdo -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 sm:gap-12 px-4 sm:px-10 items-start">
                <!-- Coluna Esquerda -->
                <div class="flex flex-col h-full">
                    <!-- Horário -->
                    <div class="border-2 border-[#69655F] rounded-2xl pb-3 pt-1 px-4 mb-6">
                        <p class="text-[#69655F] text-lg font-medium mb-1">Horário</p>
                        <p class="text-xl sm:text-2xl font-semibold">{{ turno.horario }}</p>
                    </div>

                    <!-- Salas Disponíveis -->
                    <div class="flex flex-col flex-grow">
                        <p class="font-semibold text-base sm:text-lg mb-2">Salas Disponíveis</p>
                        <div
                            class="border-2 border-[#69655F] rounded-2xl divide-y divide-[#444] flex-grow max-h-[250px] overflow-y-auto custom-scroll">
                            <div v-for="(sala, index) in salas" :key="index"
                                class="flex justify-between items-center py-3 px-4 text-base sm:text-xl font-medium">
                                <label class="flex items-center space-x-2 sm:space-x-3">
                                    <input type="radio" :value="sala.id" :checked="turno.sala.id === sala.id"
                                        v-model="salaSelecionada" class="accent-orange" />
                                    <span class="text-[#69655F]">Sala:</span><span>{{ sala.nome }}</span>
                                </label>
                                <span class="text-[#AFAFAF] text-sm sm:text-base">Capacidade: {{ sala.capacidade
                                    }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Coluna Direita -->
                <div class="flex flex-col h-full">
                    <!-- Alunos Inscritos -->
                    <div class="border-2 border-[#69655F] rounded-2xl pb-3 pt-1 px-4 mb-6">
                        <p class="text-[#69655F] text-lg font-medium mb-1">Alunos Inscritos</p>
                        <p class="text-xl sm:text-2xl font-semibold">{{ turno.totalStudents }} alunos</p>
                    </div>

                    <!-- Alunos -->
                    <div class="flex flex-col flex-grow">
                        <p class="font-semibold text-base sm:text-lg mb-2">Alunos</p>
                        <div
                            class="border-2 border-[#69655F] rounded-2xl px-4 py-2 space-y-2 custom-scroll flex-grow max-h-[250px] overflow-y-auto text-base sm:text-xl">
                            <p v-for="(aluno, index) in turno.alunos" :key="index">{{ aluno.name }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Rodapé -->
            <div
                class="flex flex-col sm:flex-row justify-between items-center mt-6 gap-4 px-4 sm:px-10 text-center sm:text-left">
                <p class="text-white text-sm sm:text-base">
                    Ao clicar "<span class="underline underline-offset-2 decoration-[#EB5E28]">concluir</span>" será
                    enviada uma notificação<span class="hidden lg:block text-center">da alteração</span>
                    <span class="sm:hidden">da alteração</span>
                </p>

                <div class="flex gap-4">
                    <button @click="$emit('close')"
                        class="px-8 sm:px-10 py-1 text-lg sm:text-2xl border border-orange rounded-full text-white font-semibold hover:scale-105 hover:shadow-lg transition">
                        Sair
                    </button>
                    <button @click="editTurno"
                        class="px-10 sm:px-16 py-1 text-lg sm:text-2xl bg-orange text-white font-semibold rounded-full hover:bg-orange/80 hover:scale-105 hover:shadow-lg transition">
                        Concluir
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { X } from 'lucide-vue-next';
import axios from 'axios';

export default {
    name: "EditarTurnoPopup",
    components: { X },
    props: {
        show: Boolean,
        turno: Object,
        course: Object,
        salas: Array
    },
    data() {
        return {
            salaSelecionada: null
        };
    },
    methods: {
        concluir() {
            this.$emit('concluir', this.salaSelecionada);
        },
        async editTurno() {
            try {
                if (this.salaSelecionada === null) {
                    this.$emit('alert')
                    this.concluir();
                    return;
                }
                
                const response = await axios.patch(`http://localhost:3000/shifts/${this.turno.id}`, {
                    classroomId: this.salaSelecionada
                });

                if (response.status === 200) {
                        const selectedSala = this.salas.find(sala => sala.id === this.salaSelecionada);
                        
                        for (const aluno of this.turno.alunos) {
                            await axios.post(`http://localhost:3000/notifications`, {
                                userId: aluno.email,
                                type: "Troca de Sala",
                                date: new Date(),
                                title: "Troca de Sala",
                                message: `O Turno ${this.turno.turno} de ${this.course.abbreviation} trocou de sala para ${selectedSala.nome}!`,
                                read: 'false'
                            });
                        }

                        const responseTeacher = await axios.get(`http://localhost:3000/teachers?name=${this.turno.docente}`);
                        const teacher = responseTeacher.data[0];
                        
                        await axios.post(`http://localhost:3000/notifications`, {
                            userId: teacher.email,
                            type: "Troca de Sala",
                            date: new Date(),
                            title: "Troca de Sala",
                            message: `O seu turno ${this.turno.turno} de ${this.course.abbreviation} trocou de sala para ${selectedSala.nome}!`,
                            read: 'false'
                        });
                        
                        this.$emit('success');
                        this.concluir();
                        this.salaSelecionada = null;
                }
            } catch (error) {
                console.error("Erro ao editar turno:", error);
                this.$emit('error'); 
            }
        }
    }
};
</script>

<style scoped>
.custom-scroll {
    scrollbar-width: thick;
    scrollbar-color: #EB5E28 transparent;
    border-radius: 16px;
}

.custom-scroll::-webkit-scrollbar {
    width: 12px;
    max-height: 10px;
}

.custom-scroll::-webkit-scrollbar-track {
    background: transparent;
    margin: 4px;
    border-radius: 100px;
}

.custom-scroll::-webkit-scrollbar-thumb {
    background-color: #EB5E28;
    border-radius: 100px;
    min-height: 20px;
    border: 2px solid #252422;
}

.custom-scroll::-webkit-scrollbar-thumb:hover {
    background-color: #ff753f;
}

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