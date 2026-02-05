# 🎓 Turnos-GO — Practical Class Shift Management (HCI)

## 📌 Overview

**Turnos-GO** is a web application designed to **support the Degree Coordination/Program Director** in **managing and adjusting practical class shifts** (TP/PL) throughout a semester, taking into account:
- capacity limits (shift + classroom),
- timetable conflicts,
- student shift-swap requests,
- teacher classroom-change requests,
- and process notifications.

This project was developed for the **Human-Computer Interaction (HCI)** course, focusing on a clear and efficient user experience for two main profiles: **Program Director** and **Student**.

---

## 🧠 Main Features

### 👤 Authentication & Roles
- Login as **Director** or **Student**
- Route protection by user type (student/director)
- Persistent session via `localStorage`

### 🧑‍🎓 Student Area
- View the **assigned timetable**
- Browse **available shifts** per course
- Submit **shift swap requests** (with validations)
- View **request history** and status (pending/approved/rejected)
- Receive relevant **notifications**

### 🧑‍💼 Program Director Area
- Dashboard with metrics and request overview
- View shifts per course and **occupancy rate**
- Manage **swap requests** (approve/reject/edit)
- **Manual allocation** of students (with conflict warnings)
- Manage **classroom-change requests** (when applicable)
- Publish/update information through data operations

### ⚠️ Conflicts & Constraints
- **Schedule conflict** warnings
- **Capacity control** per shift/classroom
- Special rules (e.g., student status) when applicable in the system flows

---

## 🧰 Tech Stack

### Frontend
- **Vue 3** + **Vite**
- **Vue Router** (navigation + guards)
- **Pinia** (auth state)
- **TailwindCSS** (+ animations)
- **Axios** (API consumption)

### Backend (mock)
- **json-server** (REST API from `trabalhodb.json`)

### Quality & Accessibility
- **pa11y** (accessibility audit tool — included in the project)

---

## ▶️ How to Run

> Requirements: **Node.js (recommended 18+)** and **npm**

### 1) Run everything with one command (recommended)
From the `project_ipm/` folder:

```bash
npm install
npm run dev
```

This will start:
- `json-server` (API) at `http://localhost:3000`
- Frontend (Vite) at `http://localhost:5173` (typical Vite port)

### 2) Alternative: run in two terminals

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

> Note: the frontend uses `http://localhost:3000` as the base URL (hardcoded). If you change the port, update the code accordingly.

---

## 🔐 Demo Credentials

### Program Director
- **Email:** `jose@di.uminho.pt`
- **Password:** `123`

### Student (example)
- **Email:** `a32324@alunos.uminho.pt`
- **Password:** `123`

(There are multiple students in the dataset in `backend/trabalhodb.json`.)

---

## 🗃️ API (json-server) — Resources

The API exposes REST collections (GET/POST/PATCH/DELETE) from `trabalhodb.json`, including:
- `/students`, `/directors`, `/teachers`
- `/courses`, `/shifts`, `/allocations`
- `/shiftRequests`, `/classroomRequests`
- `/conflicts`, `/notifications`
- `/classrooms`, `/buildings`, …

---

## 📂 Project Structure

```text
Turnos-GO-main/
├── project_ipm/
│   ├── package.json              # "dev" script with concurrently (frontend + backend)
│   ├── backend/
│   │   ├── trabalhodb.json       # dataset + json-server "API"
│   │   └── package.json
│   └── frontend/
│       ├── src/
│       │   ├── views/            # pages (Student/Director)
│       │   ├── components/       # reusable components (popups, cards, sidebar, toasts)
│       │   ├── router/           # routes + guards
│       │   ├── stores/           # Pinia store (auth)
│       │   └── middlewares/      # authentication middleware
│       ├── public/               # public assets
│       └── package.json
└── README.md
```

---

## 🧭 Main Pages (Frontend)

- `/` — Login
- `/students/home` — Student home
- `/students/horario` — Student timetable
- `/students/requisitar-troca` — Request swap
- `/students/consultar-turnos` — Browse shifts
- `/students/historico-trocas` — History

- `/directors/home` — Director home
- `/directors/consultar-turnos` — Courses/shifts
- `/directors/consultar-turnos/:id` — Course details
- `/directors/pedidos-troca` — Swap requests
- `/directors/alocar-listaAlunos` — Students list (allocation)
- `/directors/alocar-aluno/:id` — Individual allocation

---

## ✍️ Notes

- This project uses `json-server`, so data persists **only** in the JSON file unless it is reset.
- For testing, you can edit `backend/trabalhodb.json` directly.

