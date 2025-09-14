<template>
  <div class="items-center w-full h-screen bg-background_gray">
    <div class="flex flex-col lg:flex-row items-center justify-center h-full font-poppins overflow-hidden relative">
      <transition :name="transitionName" mode="out-in">
        <template v-if="!isAluno">
          <div key="default" class="flex flex-col lg:flex-row items-center h-full w-full">
            <!-- Esquerda - Direção de Curso -->
            <div
              class="relative flex-col items-center justify-center w-full h-full md:h-2/6 lg:h-full lg:w-4/6 2xl:w-1/3 overflow-hidden hidden lg:flex">
              <video autoplay muted loop playsinline class="absolute inset-0 w-full h-full object-cover z-0">
                <source src="@/assets/loginAnimation.mp4" type="video/mp4" />
                O teu navegador não suporta vídeos em HTML5.
              </video>

              <div class="absolute inset-0 bg-black opacity-10 z-10"></div>

              <div class="px-8 sm:px-14 relative z-20 text-center">
                <h1 class="text-white text-4xl sm:text-6xl font-bold mt-24 sm:mt-56 mb-8 sm:mb-14">Direção de Curso</h1>
                <p class="md:hidden lg:flex text-white text-xl sm:text-3xl font-medium leading-normal">
                  "Gerir turnos, otimizar horários e resolver conflitos numa só plataforma."
                </p>
              </div>

              <div class="flex flex-col items-center mt-10 mb-16 sm:mb-64 relative z-20">
                <button @click="toggleView(true)"
                  class="px-12 sm:px-20 py-3 m-2 border-2 border-white text-white text-lg sm:text-2xl rounded-2xl hover:scale-105 transition-all">
                  Sou Aluno
                </button>
              </div>
            </div>


            <!-- Direita - Formulário -->
            <div class="flex flex-col items-center justify-center w-full h-full px-4 sm:px-8 lg:px-16">
              <h1 class="text-white text-4xl md:text-5xl xl:text-6xl font-bold mb-14 sm:mb-20 text-center">
                Bem-vindo ao <br class="sm:hidden" /><span class="text-orange">Turno&Go!</span>
              </h1>

              <form @submit.prevent="handleLogin" class="flex flex-col items-center text-[#403D39] w-full max-w-md p-4">
                <div class="relative mb-6 w-full">
                  <input v-model="formData.identifier" type="text" aria-label="Identificador"
                    placeholder="Identificador"
                    class="w-full px-14 py-3 pl-12 rounded-md font-poppins font-medium text-sm sm:text-base" />
                  <Fingerprint class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                </div>
                <div class="relative mb-6 w-full">
                  <input :type="showPassword ? 'text' : 'password'" v-model="formData.password" aria-label="Password"
                    placeholder="Password"
                    class="w-full px-14 py-3 pl-12 pr-12 rounded-md font-poppins font-medium text-sm sm:text-base" />
                  <Lock class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                  <button type="button" @click="togglePassword"
                    :aria-label="showPassword ? 'Ocultar palavra-passe' : 'Mostrar palavra-passe'"
                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 focus:outline-none">
                    <Eye v-if="showPassword" class="w-5 h-5 text-gray-500" />
                    <EyeClosed v-else class="w-5 h-5 text-gray-500" />
                  </button>
                </div>
                <p class="underline text-white font-medium mb-8 sm:mb-14 text-sm sm:text-base">Esqueceu-se da sua
                  palavra-passe?</p>
                <button type="submit" :class="[
                  'w-full lg:w-auto px-36 py-2 items-center justify-center flex text-xl sm:text-2xl font-semibold rounded-3xl transition-all',
                  isFormValid
                    ? 'bg-orange text-white hover:bg-orange/80 hover:scale-105 hover:shadow-lg'
                    : 'bg-[#403D39] text-white cursor-not-allowed'
                ]">
                  Entrar
                </button>
              </form>
              <!-- Botão de troca de vista (mobile only) -->
              <div class="lg:hidden mt-6">
                <button @click="toggleView(!isAluno)"
                  class="px-8 md:px-20 py-2 mt-6 border-2 border-white text-white text-lg font-medium rounded-2xl hover:scale-105 transition-all">
                  {{ isAluno ? 'Sou Docente' : 'Sou Aluno' }}
                </button>
              </div>
            </div>

          </div>
        </template>

        <template v-else>
          <div key="aluno" class="flex flex-col lg:flex-row items-center h-full w-full">
            <!-- Esquerda - Formulário -->
            <div class="flex flex-col items-center justify-center w-full h-full px-4 sm:px-8 lg:px-16">
              <h1 class="text-white text-4xl md:text-5xl xl:text-6xl font-bold mb-14 sm:mb-20 text-center">
                Bem-vindo ao <br class="sm:hidden" /> <span class="text-orange">Turno&Go!</span>
              </h1>
              <form @submit.prevent="handleLogin" class="flex flex-col items-center text-[#403D39] w-full max-w-md p-4">
                <div class="relative mb-6 w-full">
                  <input v-model="formData.identifier" type="text" aria-label="Email Institucional"
                    placeholder="Email Institucional"
                    class="w-full px-14 py-3 pl-12 rounded-md font-poppins font-medium text-sm sm:text-base" />
                  <Fingerprint class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                </div>
                <div class="relative mb-6 w-full">
                  <input :type="showPassword ? 'text' : 'password'" v-model="formData.password" aria-label="Password"
                    placeholder="Password"
                    class="w-full px-14 py-3 pl-12 pr-12 rounded-md font-poppins font-medium text-sm sm:text-base" />
                  <Lock class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" />
                  <button type="button" @click="togglePassword"
                    :aria-label="showPassword ? 'Ocultar palavra-passe' : 'Mostrar palavra-passe'"
                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 focus:outline-none">
                    <Eye v-if="showPassword" class="w-5 h-5 text-gray-700" />
                    <EyeClosed v-else class="w-5 h-5 text-gray-700" />
                  </button>
                </div>
                <p class="underline text-white font-medium mb-8 sm:mb-14 text-sm sm:text-base">Esqueceu-se da sua
                  palavra-passe?</p>
                <button type="submit" :class="[
                  'w-full lg:w-auto px-36 py-2 items-center justify-center flex text-xl sm:text-2xl font-semibold rounded-3xl transition-all',
                  isFormValid
                    ? 'bg-orange text-white hover:bg-orange/80 hover:scale-105 hover:shadow-lg'
                    : 'bg-[#403D39] text-white cursor-not-allowed'
                ]">
                  Entrar
                </button>
              </form>
              <!-- Botão de troca de vista (mobile only) -->
              <div class="lg:hidden mt-6">
                <button @click="toggleView(!isAluno)"
                  class="px-8 md:px-20 py-2 border-2 mt-6 border-white text-white text-lg font-medium rounded-2xl">
                  {{ isAluno ? 'Sou Docente' : 'Sou Aluno' }}
                </button>
              </div>
            </div>

            <!-- Direita - Sou Aluno -->
            <div
              class="relative flex-col items-center justify-center w-full h-full md:h-2/6 lg:h-full lg:w-4/6 2xl:w-1/3 overflow-hidden hidden lg:flex">
              <video autoplay muted loop playsinline class="absolute inset-0 w-full h-full object-cover z-0">
                <source src="@/assets/loginAnimation.mp4" type="video/mp4" />
                O teu navegador não suporta vídeos em HTML5.
              </video>

              <div class="absolute inset-0 bg-black opacity-10 z-10"></div>
              <div class="px-14 relative z-20">
                <h1 class="text-center text-white text-6xl font-bold mt-56  mb-14">Aluno</h1>
                <p class="text-white text-3xl font-medium text-center leading-normal">
                  "Acesso rápido, simples e direto à tua gestão de turnos."
                </p>
              </div>

              <div class="flex flex-col items-center mt-10 mb-64 relative z-20">
                <button @click="toggleView(false)"
                  class="px-12 sm:px-20 py-3 m-2 border-2 border-white text-white text-2xl rounded-2xl hover:scale-105 transition-all">Sou
                  Docente</button>
              </div>
            </div>
          </div>
        </template>
      </transition>
    </div>
  </div>
  <ErrorToast v-if="showErrorToast" :error-message="false" />
</template>

<script>
import { useAuthStore } from '@/stores/auth'
import { Fingerprint, Lock, Eye, EyeClosed } from 'lucide-vue-next'
import axios from 'axios'
import ErrorToast from '../components/ErrorToast.vue';

const API_URL = 'http://localhost:3000'




export default {
  name: 'Login',
  components: {
    Fingerprint,
    Lock,
    Eye,
    EyeClosed,
    ErrorToast
  },
  data() {
    return {
      isAluno: false,
      transitionName: 'slide-left',
      formData: {
        identifier: '',
        password: ''
      },
      showPassword: false,
      showErrorToast: false
    }
  },
  computed: {
    isFormValid() {
      return this.formData.identifier.trim() !== '' && this.formData.password.trim() !== '';
    }
  },
  methods: {
    async handleLogin() {
      if (!this.formData.identifier.trim() || !this.formData.password.trim()) {
        this.showErrorToast = true
        setTimeout(() => {
          this.showErrorToast = false
        }, 5000)
        return;
      }
      try {
        const endpoint = this.isAluno ? '/students' : '/directors'
        const response = await axios.get(
          `${API_URL}${endpoint}`, {
          params: {
            email: this.formData.identifier,
            password: this.formData.password
          }
        }
        )

        const data = response.data
        if (data && data.length > 0) {
          const authStore = useAuthStore()
          authStore.login({
            id: data[0].id,
            name: data[0].name,
            email: data[0].email,
            type: this.isAluno ? 'student' : 'director'
          })

          this.$router.push(this.isAluno ? '/students/home' : '/directors/home')
        } else {
          alert('Credenciais inválidas')
        }
      } catch (error) {
        console.error('Erro ao fazer login:', error)
        this.showErrorToast = true
        setTimeout(() => {
          this.showErrorToast = false
        }, 5000)
      }
    },
    toggleView(aluno) {
      this.transitionName = aluno ? 'slide-left' : 'slide-right';
      this.isAluno = aluno;
    },
    togglePassword() {
      this.showPassword = !this.showPassword
    }
  }
}
</script>

<style scoped>
/* Direção: para a esquerda (Diretor → Aluno) */
.slide-left-enter-active,
.slide-left-leave-active {
  transition: all 0.35s ease;
}

.slide-left-enter-from {
  opacity: 0;
  transform: translateX(100%);
}

.slide-left-leave-to {
  opacity: 0;
  transform: translateX(-100%);
}

/* Direção: para a direita (Aluno → Diretor) */
.slide-right-enter-active,
.slide-right-leave-active {
  transition: all 0.35s ease;
}

.slide-right-enter-from {
  opacity: 0;
  transform: translateX(-100%);
}

.slide-right-leave-to {
  opacity: 0;
  transform: translateX(100%);
}
</style>
