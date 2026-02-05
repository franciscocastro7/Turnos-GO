# 🎓 Turnos-GO — Gestão de Turnos Práticos (IPM)

## 📌 Visão Geral

**Turnos-GO** é uma aplicação web para **auxiliar a Direção de Curso** na **gestão e ajuste de turnos práticos** (TP/PL) de um semestre, tendo em conta:
- limites de capacidade (turma + sala),
- conflitos de horário,
- pedidos de troca de turno por alunos,
- pedidos de alteração de sala por docentes,
- e notificações do processo.

O sistema foi desenvolvido no âmbito da UC **Interface Pessoa-Máquina (IPM)** e foca-se numa experiência de utilização clara e eficiente para os dois perfis principais: **Diretor de Curso** e **Aluno**.

---

## 🧠 Funcionalidades Principais

### 👤 Autenticação e Perfis
- Login com perfil **Diretor** ou **Aluno**
- Proteção de rotas por tipo de utilizador (student/director)
- Sessão persistente via `localStorage`

### 🧑‍🎓 Área do Aluno
- Consulta do **horário atribuído**
- Consulta de **turnos disponíveis** por UC
- **Requisição de troca de turnos** (com validações)
- Acesso a **histórico** de pedidos e estado (pendente/aprovado/rejeitado)
- Receção de **notificações** relevantes

### 🧑‍💼 Área do Diretor de Curso
- Painel com métricas e resumo de pedidos
- Consulta de turnos por UC e **taxa de ocupação**
- Gestão de **pedidos de troca** (aprovar/rejeitar/editar)
- **Alocação manual** de alunos (com avisos de conflitos)
- Gestão de **pedidos de mudança de sala** (quando aplicável)
- Publicação/atualização de informação (via operações sobre os dados)

### ⚠️ Conflitos e Restrições
- Avisos de **conflitos de horário**
- Controlo de **capacidade** por turno/sala
- Regras especiais (ex.: estatutos), quando aplicável nos fluxos do sistema

---

## 🧰 Tecnologias

### Frontend
- **Vue 3** + **Vite**
- **Vue Router** (navegação e guards)
- **Pinia** (estado de autenticação)
- **TailwindCSS** (+ animações)
- **Axios** (consumo da API)

### Backend (mock)
- **json-server** (API REST a partir de `trabalhodb.json`)

### Qualidade & Acessibilidade
- **pa11y** (ferramenta de auditoria de acessibilidade — disponível no projeto)

---

## ▶️ Como Executar

> Requisitos: **Node.js (recomendado 18+)** e **npm**

### 1) Executar tudo com um comando (recomendado)
Na pasta `project_ipm/`:

```bash
npm install
npm run dev
```

Isto levanta:
- `json-server` (API) em `http://localhost:3000`
- Frontend (Vite) em `http://localhost:5173` (porta típica do Vite)

### 2) Alternativa: executar em dois terminais

**Terminal A — API**
```bash
cd project_ipm/backend
npm install
npx json-server -w trabalhodb.json --port 3000
```

**Terminal B — Frontend**
```bash
cd project_ipm/frontend
npm install
npm run dev
```

> Nota: o frontend usa `http://localhost:3000` como base URL (hardcoded). Se mudares a porta, atualiza o código.

---

## 🔐 Credenciais de Demonstração

### Diretor de Curso
- **Email:** `jose@di.uminho.pt`
- **Password:** `123`

### Aluno (exemplo)
- **Email:** `a32324@alunos.uminho.pt`
- **Password:** `123`

(Existem vários alunos no dataset em `backend/trabalhodb.json`.)

---

## 🗃️ API (json-server) — Recursos

A API expõe coleções REST (GET/POST/PATCH/DELETE) a partir de `trabalhodb.json`, incluindo:
- `/students`, `/directors`, `/teachers`
- `/courses`, `/shifts`, `/allocations`
- `/shiftRequests`, `/classroomRequests`
- `/conflicts`, `/notifications`
- `/classrooms`, `/buildings`, …

---

## 📂 Estrutura do Projeto

Turnos-GO-main/
│
├── project_ipm/
│   ├── package.json               # script "dev" com concurrently (frontend + backend)
│   │
│   ├── backend/
│   │   ├── trabalhodb.json        # dataset + "API" json-server
│   │   └── package.json
│   │
│   └── frontend/
│       ├── src/
│       │   ├── views/             # páginas (Aluno/Diretor)
│       │   ├── components/        # componentes reutilizáveis (popups, cards, sidebar, toasts)
│       │   ├── router/            # rotas + guards
│       │   ├── stores/            # Pinia store (auth)
│       │   └── middlewares/       # middleware de autenticação
│       │
│       ├── public/                # assets públicos
│       └── package.json
│
└── README.md

---

## 🧭 Páginas Principais (Frontend)

- `/` — Login
- `/students/home` — Home do aluno
- `/students/horario` — Horário do aluno
- `/students/requisitar-troca` — Requisitar troca
- `/students/consultar-turnos` — Consultar turnos
- `/students/historico-trocas` — Histórico

- `/directors/home` — Home do diretor
- `/directors/consultar-turnos` — Turnos por UC
- `/directors/consultar-turnos/:id` — Detalhe por UC
- `/directors/pedidos-troca` — Pedidos de troca
- `/directors/alocar-listaAlunos` — Lista de alunos para alocação
- `/directors/alocar-aluno/:id` — Alocação individual

---

## ✍️ Notas

- Este projeto usa `json-server`, pelo que os dados persistem **apenas** no ficheiro JSON enquanto não for reposto.
- Para testes, podes editar diretamente `backend/trabalhodb.json`.

---

## 👥 Autores

Grupo: *(preencher)*
UC: Interface Pessoa-Máquina (IPM) — Universidade do Minho
Ano letivo: 2024/2025
