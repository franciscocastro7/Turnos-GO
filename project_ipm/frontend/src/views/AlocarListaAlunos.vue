<template>
  <div class="bg-background_gray h-screen w-full flex flex-col font-poppins">
    <h1 v-if="alunos.length !== 0" class="px-20 xl:px-8 py-8 md:py-7 xl:py-10 text-sm md:text-lg font-poppins font-semibold text-white">
      <span class="text-white/50">Gestão de Turnos /</span> Alocar Alunos
    </h1>

    <div v-if="alunos.length === 0" class="flex-grow flex flex-col justify-center items-center">
      <span
        class="text-white text-lg sm:text-xl md:text-2xl font-poppins font-semibold text-center">
        Não existem alunos a alocar
      </span>
      <div class="flex justify-center items-center text-[#D9D9D9]">
        <a href="/directors/home" class="underline text-xl decoration-orange">Voltar</a>
      </div>
    </div>

    <div v-if="alunos.length !== 0" class="p-8">
      <div class="flex items-center pb-4">
        <input v-model="searchQuery" type="text" placeholder="Filtrar por Nome..." aria-label="Filtrar por Nome"
          class="px-2 bg-background_gray placeholder-text_gray text-text_gray rounded-md w-1/2 lg:w-1/4 border-2 border-[#69655F] focus-visible: outline-none mr-4" />
        <div class="relative">
          <button @click="handleFilterClick" aria-label="Filtrar Click"
            class="flex items-center gap-4 bg-background_gray font-poppins px-2 rounded-md border-2 transition-all"
            :class="[
              selectedOption
                ? 'border-orange text-white border-solid'
                : 'border-[#69655F] text-white/50 border-dashed hover:border-orange hover:text-white hover:border-solid'
            ]">
            <CircleMinus v-if="selectedOption" class="w-5 h-5 text-white" @click.stop="clearSelection" />
            <CirclePlus v-else class="w-5 h-5 text-white" />

            {{ selectedOption || 'Estatuto' }}
          </button>

          <!-- Pop-up do Estado -->
          <div v-if="isOpen"
            class="absolute left-0 top-full mt-2 w-40 md:w-48 bg-[#252422] font-medium rounded-md shadow-lg z-50">
            <div class="border-2 rounded-md border-[#403D39]">
              <div class="text-white px-2 border-b-2 border-[#403D39] font-medium">Estatuto</div>
              <button v-for="(option, index) in options" :key="option" @click="selectOption(option)"
                aria-label="Opção Selecionada"
                class="block w-full text-left px-4 py-2 text-white hover:bg-[#3D3A37] transition-all" :class="[
                  { 'bg-[#3D3A37]': selectedOption === option },
                  { 'border-b-2 border-[#403D39]': index !== options.length - 1 }
                ]">
                {{ option }}
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="flex-grow overflow-x-auto">
        <table class="w-full text-white text-left border-collapse">
          <thead>
            <tr class="border-b-2 font-poppins border-text-gray text-[#CCC5B9] border-[#69655F]">
              <th class="px-4 py-2">Nome do Aluno</th>
              <th class="px-4 py-2">Nº de Aluno</th>
              <th class="px-4 py-2">Estatuto</th>
              <th class="px-4 py-2">Conflitos</th>
              <th class="px-4 py-2"></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(aluno, index) in paginatedStudents" :key="index"
              class="border-b border-text-gray border-[#69655F] hover:bg-[#2A2927] transition-all">
              <td class="px-4 py-3">{{ aluno.nome }}</td>
              <td class="px-4 py-3">{{ aluno.numero }}</td>
              <td class="px-4 py-3">{{ aluno.estatuto }}</td>
              <td class="px-4 py-3">
                <span>{{ aluno.conflitos }}</span>
              </td>
              <td class="px-4 py-3">
                <button class="text-orange flex items-center text-center" aria-label="Alocar Aluno">
                  <SquarePen class="w-7 h-7" @click="this.$router.push(`/directors/alocar-aluno/${aluno.id}`)" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div v-if="alunos.length !== 0"
      class="text-center text-white mt-auto pt-10 p-8 flex items-center justify-center gap-4">
      <button @click="currentPage--" :disabled="currentPage === 1" aria-label="Navegação"
        class="px-4 py-2 background_gray rounded-md self-center justify-center">
        <SquareArrowLeft v-if="currentPage === 1" class="w-7 h-7 text-white/50" />
        <SquareArrowLeft v-else class="w-7 h-7 text-text_gray" />
      </button>
      <span>Página {{ currentPage }} de {{ totalPages }}</span>
      <button @click="currentPage++" :disabled="currentPage === totalPages" aria-label="Navegação"
        class="justify-center items-center px-4 py-2 background_gray rounded-md">
        <SquareArrowRight v-if="currentPage === totalPages" class="w-7 h-7 text-white/50" />
        <SquareArrowRight v-else class="w-7 h-7 text-text_gray" />
      </button>
    </div>
  </div>
</template>

<script>
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue';
import { CirclePlus, CircleMinus, SquareArrowRight, SquareArrowLeft, SquarePen } from 'lucide-vue-next';
import axios from 'axios';

export default {
  name: 'AlocarListaAlunos',
  components: {
    CirclePlus,
    CircleMinus,
    SquareArrowRight,
    SquareArrowLeft,
    SquarePen
  },
  setup() {
    const isOpen = ref(false);
    const selectedOption = ref('');
    const options = ['N/A', 'TE', 'EA'];
    const hovered = ref(false);
    const searchQuery = ref('');

    const alunos = ref([]);

    async function getAlunosConflitos() {
      try {
        const response = await axios.get('http://localhost:3000/conflicts');

        if (response.status === 200) {
          const data = response.data;
          const ids = data.map(item => item.studentId);

          if (ids.length === 0) {
            alunos.value.length = 0
            return;
          }


          ids.forEach(async aluno => {
            const responseAlunos = await axios.get(`http://localhost:3000/students/${aluno}`);

            if (responseAlunos.status === 200) {
              const alunoData = responseAlunos.data;
              const alunoIndex = alunos.value.findIndex(a => a.numero === alunoData.email.split('@')[0].toUpperCase());

              if (alunoIndex !== -1) {
                alunos.value[alunoIndex].conflitos += 1
              } else {
                alunos.value.push({
                  id: alunoData.id,
                  nome: alunoData.name,
                  numero: alunoData.email.split('@')[0].toUpperCase(),
                  estatuto: alunoData.specialStatus,
                  conflitos: 1
                });
              }
            } else {
              console.error('Error fetching student data:', responseAlunos.status);
            }
          });
        } else {
          console.error('Error fetching data:', response.status);
        }
      }
      catch (error) {
        console.error('Error fetching data:', error);
      }
    }

    function removeAccents(str) {
      return str.normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .toLowerCase();
    }

    const filteredStudents = computed(() => {
      const normalizedSearch = removeAccents(searchQuery.value);

      return alunos.value.filter(aluno => {
        const normalizedName = removeAccents(aluno.nome);
        const matchesName = normalizedName.includes(normalizedSearch);
        const matchesStatus = !selectedOption.value || aluno.estatuto === selectedOption.value;
        return matchesName && matchesStatus;
      });
    });

    const currentPage = ref(1);

    const paginatedStudents = computed(() => {
      const filtered = filteredStudents.value;
      const start = (currentPage.value - 1) * 9;
      const end = start + 9;
      return filtered.slice(start, end);
    });

    const totalPages = computed(() => {
      if (filteredStudents.value.length === 0) {
        return 1;
      }
      return Math.ceil(filteredStudents.value.length / 9);
    });

    const toggleDropdown = () => {
      isOpen.value = !isOpen.value;
    };

    const selectOption = (option) => {
      selectedOption.value = option;
      isOpen.value = false;
    };

    const clearSelection = () => {
      selectedOption.value = '';
    };

    const handleFilterClick = () => {
      if (selectedOption.value) {
        selectedOption.value = '';
      } else {
        isOpen.value = !isOpen.value;
      }
    };

    watch(selectedOption, (newValue) => {
      if (newValue) {
        console.log('Estado selecionado:', newValue);
      }
    });

    onMounted(() => {
      getAlunosConflitos();
    });

    return {
      isOpen,
      selectedOption,
      options,
      hovered,
      searchQuery,
      alunos,
      filteredStudents,
      toggleDropdown,
      selectOption,
      clearSelection,
      currentPage,
      totalPages,
      paginatedStudents,
      handleFilterClick
    };
  },
};
</script>