<template>
    <div>
        <!-- Overlay escuro quando menu está aberto (apenas mobile) -->
        <div v-if="islowerWindow && isMenuOpen" class="fixed inset-0 bg-black bg-opacity-50 z-40"
            @click="isMenuOpen = false"></div>

        <!-- Sidebar normal para telas grandes -->
        <aside v-if="!islowerWindow" class="fixed w-1/6 h-screen bg-[#21201E]">
            <div>
                <h1 class="font-poppins font-bold text-orange lg:text-2xl xl:text-4xl text-center pt-10">
                    <a :href="isAluno ? '/students/home' : '/directors/home'">Turnos&Go!</a>
                </h1>
                <h2 class="font-protest lg:text-2xl xl:text-4xl text-white text-center pb-8">
                    <a :href="isAluno ? '/students/home' : '/directors/home'">
                        {{ isAluno ? 'Student' : 'Director' }}
                    </a>
                </h2>
            </div>

            <div class="pl-12 pr-8">
                <div
                    class="text-sm lg:text-base xl:text-lg 2xl:text-xl flex flex-col justify-start space-y-8 font-poppins pt-8">
                    <div>
                        <h1 class="text-white">Principal</h1>
                        <div class="h-0.5 w-5/6 bg-white"></div>
                        <div
                            class="py-6 flex flex-col space-y-6 font-light text-sm lg:text-base xl:text-lg 2xl:text-xl">
                            <button @click="goToInicio" aria-label="Início"
                                :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute.includes('/home') ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                <House class="w-6 h-6" />
                                <span>Início</span>
                            </button>
                            <button v-if="isAluno" @click="goToHorario" aria-label="Horário"
                                :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/students/horario' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                <CalendarDays class="w-6 h-6" />
                                <span>Horário</span>
                            </button>
                            <button @click="goToNotificacoes" aria-label="Notificações"
                                :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/notificacoes' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                <Bell class="w-6 h-6" />
                                <span>Notificações</span>
                                <div v-if="notifications > 0"
                                    class="ml-2 bg-orange text-white text-base text-center font-bold w-6 h-6 rounded-full">
                                    {{ notifications }}</div>
                            </button>
                        </div>
                    </div>

                    <div class="text-sm lg:text-base xl:text-lg 2xl:text-xl">
                        <h1 class="text-white">Gestão de Turnos</h1>
                        <div class="h-0.5 w-5/6 bg-white"></div>
                        <div class="py-6 flex flex-col space-y-6 font-light ">
                            <template v-if="isAluno">
                                <button @click="goToRequisitarTroca" aria-label="Requisitar Troca"
                                    :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/students/requisitar-troca' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <RefreshCw class="w-6 h-6" />
                                    <span>Requisitar Troca</span>
                                </button>
                                <button @click="goToConsultarTurnos" aria-label="Consultar Turnos"
                                    :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/students/consultar-turnos' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <Search class="w-6 h-6" />
                                    <span>Consultar Turnos</span>
                                </button>
                                <button @click="goToHistoricoTrocas" aria-label="Histórico de Trocas"
                                    :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/students/historico-trocas' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <FileText class="w-6 h-6" />
                                    <span>Histórico de Trocas</span>
                                </button>
                            </template>
                            <template v-else>
                                <button @click="goToPedidosTroca" aria-label="Pedidos de Troca"
                                    :class="`self-start text-center flex flex-row items-center space-x-2  hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/directors/pedidos-troca' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <RefreshCw class="w-6 h-6" />
                                    <span>Pedidos Troca</span>
                                </button>
                                <button @click="goToAlocarAlunos" aria-label="Alocar Alunos"
                                    :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/directors/alocar-listaAlunos' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <Wrench class="w-6 h-6" />
                                    <span>Alocar Alunos</span>
                                </button>
                                <button @click="goToConsultarTurnos" aria-label="Consultar Turnos"
                                    :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/directors/consultar-turnos' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <Search class="w-6 h-6" />
                                    <span>Consultar Turnos</span>
                                </button>
                            </template>
                        </div>
                    </div>

                    <div class="text-sm lg:text-base xl:text-lg 2xl:text-xl">
                        <h1 class="text-white">Opções</h1>
                        <div class="h-0.5 w-5/6 bg-white"></div>
                        <div
                            class="py-6 flex flex-col space-y-6 font-light text-sm lg:text-base xl:text-lg 2xl:text-xl">
                            <button @click="goToLogin" aria-label="Terminar Sessão"
                                :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                <LogOut class="w-6 h-6" />
                                <span>Terminar Sessão</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Rodapé do usuário -->
            <div :class="['bg-[#2A2927] flex items-center rounded-2xl  mx-4 mb-4', isAluno ? 'mt-3 2xl:mt-0 p-5' : 'mt-16 2xl:mt-10 p-4']">
                <img :src="[isAluno ? '/student.png' : '/diretor.png']" alt="Estudante"
                :class="[isAluno ? 'w-[8vh] h-[8vh]' : 'w-[9vh] h-[9vh]', 'rounded-full mr-2']" />
                <div>
                    <h1 class="text-white text-base sm:text-xl md:text-2xl font-semibold">
                        {{ user.name }}
                    </h1>
                    <p class="text-orange text-sm font-semibold">
                        {{ user.email }}
                    </p>
                </div>
            </div>
        </aside>

        <!-- Hamburger button para telas pequenas -->
        <button v-else @click="isMenuOpen = true" aria-label="Sidebar hamburger"
            class="fixed top-4 left-4 z-50 p-2 rounded-md bg-background-gray text-orange">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 hover:scale-110 transition-all hover:shadow-xl "
                fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            </svg>
        </button>

        <!-- Menu móvel (drawer) -->
        <aside v-if="islowerWindow && isMenuOpen"
            class="fixed w-64 lg:w-80 h-screen bg-[#21201E] z-50 transition-transform duration-300 ease-in-out">
            <div class="flex justify-between items-center px-6 py-3 border-b  border-white/25">
                <div class="text-center">
                    <h1 class="font-poppins font-bold text-orange text-2xl">
                        <a :href="isAluno ? '/students/home' : '/directors/home'">Turnos&Go!</a>
                    </h1>
                    <h2 class="font-protest font-bold text-white text-2xl">
                        <a :href="isAluno ? '/students/home' : '/directors/home'">
                            {{ isAluno ? 'Student' : 'Director' }}
                        </a>
                    </h2>
                </div>
                <button @click="isMenuOpen = false" aria-label="Fechar Sidebar" class="text-white p-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
                        stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <div class="overflow-y-auto h-full pb-20">
                <div class="pl-6 pr-4">
                    <div class="text-base flex flex-col justify-start space-y-8 font-poppins pt-4">
                        <div>
                            <h1 class="text-white">Principal</h1>
                            <div class="h-0.5 w-5/6 bg-white"></div>
                            <div class="py-4 flex flex-col space-y-4 font-light">
                                <button @click="goToInicio" aria-label="Início"
                                    :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute.includes('/home') ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <House class="w-5 h-5" />
                                    <span>Início</span>
                                </button>
                                <button v-if="isAluno" @click="goToHorario" aria-label="Horário"
                                    :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/students/horario' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <CalendarDays class="w-5 h-5" />
                                    <span>Horário</span>
                                </button>
                                <button @click="goToNotificacoes" aria-label="Notificações"
                                    :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/notificacoes' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <Bell class="w-5 h-5" />
                                    <span>Notificações</span>
                                    <div v-if="notifications > 0"
                                        class="ml-2 bg-orange text-white text-sm text-center font-bold w-5 h-5 rounded-full flex items-center justify-center">
                                        {{ notifications }}</div>
                                </button>
                            </div>
                        </div>

                        <div>
                            <h1 class="text-white">Gestão de Turnos</h1>
                            <div class="h-0.5 w-5/6 bg-white"></div>
                            <div class="py-4 flex flex-col space-y-4 font-light">
                                <template v-if="isAluno">
                                    <button @click="goToRequisitarTroca" aria-label="Requisitar Troca"
                                        :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/students/requisitar-troca' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                        <RefreshCw class="w-5 h-5" />
                                        <span>Requisitar Troca</span>
                                    </button>
                                    <button @click="goToConsultarTurnos" aria-label="Consultar Turnos"
                                        :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/students/consultar-turnos' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                        <Search class="w-5 h-5" />
                                        <span>Consultar Turnos</span>
                                    </button>
                                    <button @click="goToHistoricoTrocas" aria-label="Histórico de Trocas"
                                        :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/students/historico-trocas' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                        <FileText class="w-5 h-5" />
                                        <span>Histórico de Trocas</span>
                                    </button>
                                </template>
                                <template v-else>
                                    <button @click="goToPedidosTroca" aria-label="Pedidos de Troca"
                                        :class="`self-start text-center flex flex-row items-center space-x-2  hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/directors/pedidos-troca' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                        <RefreshCw class="w-5 h-5" />
                                        <span>Pedidos Troca</span>
                                    </button>
                                    <button @click="goToAlocarAlunos" aria-label="Alocar Alunos"
                                        :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/directors/alocar-listaAlunos' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                        <Wrench class="w-5 h-5" />
                                        <span>Alocar Alunos</span>
                                    </button>
                                    <button @click="goToConsultarTurnos" aria-label="Consultar Turnos"
                                        :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/directors/consultar-turnos' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                        <Search class="w-5 h-5" />
                                        <span>Consultar Turnos</span>
                                    </button>
                                </template>
                            </div>
                        </div>

                        <div>
                            <h1 class="text-white">Opções</h1>
                            <div class="h-0.5 w-5/6 bg-white"></div>
                            <div class="py-4 flex flex-col space-y-4 font-light">
                                <button @click="goToLogin" aria-label="Terminar Sessão"
                                    :class="`self-start text-center flex flex-row items-center space-x-2 hover:text-orange hover:font-semibold hover:underline transition-all ${currentRoute === '/' ? 'text-orange font-semibold hover:no-underline' : 'text-white'}`">
                                    <LogOut class="w-5 h-5" />
                                    <span>Terminar Sessão</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Rodapé do usuário -->
                <div
                    class="bg-[#2A2927] flex items-center p-4 rounded-2xl mt-4 mx-4 mb-4 absolute bottom-0 left-0 right-0">
                    <img :src="[isAluno ? '/student.png' : '/diretor.png']" alt="Estudante"
                        :class="[isAluno ? 'w-11 h-11' : 'w-12 h-12', 'rounded-full mr-2']" />
                    <div class="truncate">
                        <h1 class="text-white text-sm font-semibold truncate">
                            {{ user.name }}
                        </h1>
                        <p class="text-orange text-xs font-semibold truncate">
                            {{ user.email }}
                        </p>
                    </div>
                </div>
            </div>
        </aside>
    </div>
</template>

<script>
import { House, Wrench, CalendarDays, Bell, RefreshCw, Search, FileText, LogOut } from 'lucide-vue-next';
import { useAuthStore } from '@/stores/auth';
import { ref, onMounted } from 'vue';
import axios from 'axios';

export default {
    name: 'Sidebar',
    components: {
        House,
        Wrench,
        CalendarDays,
        Bell,
        RefreshCw,
        Search,
        FileText,
        LogOut
    },
    data() {
        return {
            islowerWindow: window.innerWidth < 1500,
            isMenuOpen: false
        }
    },
    setup() {
        const user = ref({
            name: '',
            email: ''
        });
        const notifications = ref(0)

        onMounted(() => {
            const authStore = useAuthStore();

            user.value.name = authStore.user?.name;
            user.value.email = authStore.user?.email;

            axios.get(`http://localhost:3000/notifications?userId=${authStore.user?.email}`)
                .then(response => {
                    const data = response.data.filter(notification => notification.read === 'false').length;
                    notifications.value = data;
                })
                .catch(error => {
                    console.error('Error fetching notifications:', error);
                });
        });

        return {
            user,
            notifications
        };
    },
    computed: {
        isAluno() {
            const authStore = useAuthStore();
            return authStore.isStudent();
        },
        currentRoute() {
            return this.$route.path;
        }
    },
    methods: {
        goToInicio() {
            this.isMenuOpen = false;
            this.$router.push(this.isAluno ? '/students/home' : '/directors/home');
        },
        goToHorario() {
            this.isMenuOpen = false;
            this.$router.push('/students/horario');
        },
        goToNotificacoes() {
            this.isMenuOpen = false;
            this.$router.push('/notificacoes');
        },
        goToRequisitarTroca() {
            this.isMenuOpen = false;
            this.$router.push('/students/requisitar-troca');
        },
        goToPedidosTroca() {
            this.isMenuOpen = false;
            this.$router.push('/directors/pedidos-troca');
        },
        goToConsultarTurnos() {
            this.isMenuOpen = false;
            this.$router.push(this.isAluno ? '/students/consultar-turnos' : '/directors/consultar-turnos');
        },
        goToHistoricoTrocas() {
            this.isMenuOpen = false;
            this.$router.push('/students/historico-trocas');
        },
        goToAlocarAlunos() {
            this.isMenuOpen = false;
            this.$router.push('/directors/alocar-listaAlunos');
        },
        goToLogin() {
            this.isMenuOpen = false;
            const authStore = useAuthStore();
            authStore.logout();
            this.$router.push('/');
        },
        handleResize() {
            this.islowerWindow = window.innerWidth < 1500;
            if (!this.islowerWindow) {
                this.isMenuOpen = false;
            }
        }
    },
    mounted() {
        window.addEventListener('resize', this.handleResize);
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.handleResize);
    }
}
</script>