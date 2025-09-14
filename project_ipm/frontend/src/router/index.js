import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Home from '../views/Home.vue'
import Horario from '@/views/Horario.vue'
import Requisitar from '@/views/Requisitar.vue'
import Notifications from '@/views/Notifications.vue'
import ConsultarTurnos from '@/views/ConsultarTurnos.vue'
import HistoricoTrocas from '@/views/HistoricoTrocas.vue'
import InicioDiretor from '@/views/InicioDiretor.vue'
import ConsultarTurnosDiretor from '@/views/ConsultarTurnosDiretor.vue'
import AlocarListaAlunos from '@/views/AlocarListaAlunos.vue'
import PedidosTroca from '@/views/PedidosTroca.vue'
import AlocarAluno from '@/views/AlocarAluno.vue'
import ConsultarTurnosDiretorCadeira from '@/views/ConsultarTurnosDiretorCadeira.vue'
import authmiddleware from '@/middlewares/auth'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'login',
      component: Login,
    },
    {
      path: '/students/home',
      name: 'inicio-aluno',
      component: Home,
      meta: { type: 'student' }
    },
    {
      path: '/directors/home',
      name: 'inicio-diretor',
      component: InicioDiretor,
      meta: { type: 'director' }
    },
    {
      path: '/students/horario',
      name: 'horario',
      component: Horario,
      meta: { type: 'student' }
    },
    {
      path: '/students/requisitar-troca',
      name: 'requisitar',
      component: Requisitar,
      meta: { type: 'student' }
    },
    {
      path: '/notificacoes',
      name: 'notificacoes',
      component: Notifications
    },
    {
      path: '/directors/consultar-turnos',
      name: 'consultar-turnos-diretor',
      component: ConsultarTurnosDiretor,
      meta: { type: 'director' }
    },
    {
      path: '/directors/consultar-turnos/:id',
      name: 'consultar-turnos-diretor-cadeira',
      component: ConsultarTurnosDiretorCadeira,
      meta: { type: 'director' },
      props: true
    },
    {
      path: '/students/consultar-turnos',
      name: 'consultar-turnos-aluno',
      component: ConsultarTurnos,
      meta: { type: 'student' }
    },
    {
      path: '/students/historico-trocas',
      name: 'historico-trocas',
      component: HistoricoTrocas,
      meta: { type: 'student' }
    },
    {
      path: '/directors/pedidos-troca',
      name: 'pedidos-troca',
      component: PedidosTroca,
      meta: { type: 'director' }
    },
    {
      path: '/directors/alocar-listaAlunos',
      name: 'AlocarListaAlunos',
      component: AlocarListaAlunos,
      meta: { type: 'director' }
    },
    {
      path: '/directors/alocar-aluno/:id',
      name: 'AlocarAluno',
      component: AlocarAluno,
      meta: { type: 'director' },
      props: true
    }
  ]
})

router.beforeEach(authmiddleware);

export default router
