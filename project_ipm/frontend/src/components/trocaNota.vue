<template>
    <div class="nota" :class="{ 'nota-nao': estatuto === 'N/A' }">
      <div class="pb-2">
        <p>
          <strong class="flex items-center gap-2 font-bold"> 
            <CircleAlert class="w-5 h-5" :class="estatuto === 'N/A' ? 'text-[#DC2626]' : 'text-[#28A745]'"></CircleAlert> 
            Nota
          </strong>
        </p>
      </div>
      <div class="pb-2">
				<p>
					Na eventualidade de um turno estar cheio, se o aluno tiver estatuto, a troca deverá ser aceite.
				</p>
			</div>
			<div class="pb-2">
				<p>
					<span class="font-semibold">Situação aplica-se ao aluno? </span>
        	<span :class="aplicaClass">{{ aplicaTexto }}</span>
				</p>
			</div>
    </div>
</template>
  

<script>
import { CircleAlert } from 'lucide-vue-next';

export default {
  name: 'NotaEstatuto',
	components: { CircleAlert },
  props: {
    estatuto: {
      type: String,
      required: true
    }
  },
  computed: {
    aplicaTexto() {
      return this.estatuto === 'N/A' ? 'Não' : 'Sim';
    },
    aplicaClass() {
      return this.estatuto === 'N/A' ? 'nao' : 'sim';
    }
  }
}
</script>

<style scoped>
.nota {
  background-color: rgba(64, 61, 57, 0.4); /* #403D39 com 40% de opacidade*/
  padding: 8px;
  border-radius: 5px;
  color: #f7f4ec;
	border-left: 10px solid #28A745;
	font-size: 0.9rem;
}

.nota-nao {
  border-left: 10px solid #DC2626;
}

.nota strong {
  color: #28A745;
	font-size: text-2xl;
}

.nota-nao strong {
  color: #DC2626;
}

.sim {
  color: #28A745;
	font-weight: bold;
}

.nao {
  color: #DC2626;
	font-weight: bold;
}
</style>
