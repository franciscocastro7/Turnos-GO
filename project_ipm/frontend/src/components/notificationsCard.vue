<template>
    <div class="w-full max-w-[500px] bg-[#403D39] rounded-lg font-poppins text-white flex flex-col min-h-[200px] mx-auto">
        <!-- Card Header -->
        <div class="flex flex-row space-x-2 sm:space-x-3 items-center p-2 sm:p-3 pb-1">
            <CircleUserRound :stroke-width="0.75" class="h-8 w-8 sm:h-10 sm:w-10" />
            <div class="flex flex-col">
                <h1 class="text-white text-base sm:text-xl truncate max-w-[220px] sm:max-w-full">{{ title }}</h1>
                <div class="flex flex-col xs:flex-row xs:space-x-2 sm:items-center">
                    <span class="text-[#CCC5B9] text-xs sm:text-sm md:text-base font-light">{{ date }}</span>
                    <div class="hidden xs:block bg-[#CCC5B9] items-center justify-center text-white font-bold px-1.5 w-2 py-1.5 h-2 rounded-full"></div>
                    <span class="text-[#CCC5B9] text-xs sm:text-sm md:text-base font-light">{{ type }}</span>
                </div>
            </div>
        </div>
        <!-- Message Content -->
        <div class="px-4 sm:px-8 md:px-16 py-2 flex-grow text-sm sm:text-base">{{ message }}</div>
        <!-- Buttons Container -->
        <div v-if="!read" class="justify-end flex flex-col xs:flex-row space-y-2 xs:space-y-0 xs:space-x-2 p-2 sm:pt-3 sm:pb-2 sm:pr-2 mt-auto">
            <button @click="readNotification(id)" class="px-4 sm:px-8 py-0.5 border rounded-2xl text-white text-sm sm:text-base font-semibold border-orange bg-[#403D39] hover:bg-orange hover:scale-105 transition-all">Ignorar</button>
            <button @click="consultar(type, id)" class="px-4 sm:px-8 py-0.5 rounded-2xl text-white text-sm sm:text-base font-semibold bg-orange hover:scale-105 hover:bg-orange/80 transition-all">Consultar</button>
        </div>
        <div v-else class="justify-end flex p-2 sm:pt-3 sm:pb-2 sm:pr-2 mt-auto">
            <button @click="clearNotification(id)" class="px-4 sm:px-8 py-0.5 border rounded-2xl text-white text-sm sm:text-base font-semibold border-orange bg-[#403D39]">Limpar</button>
        </div>
    </div>
</template>

<script setup>
import { CircleUserRound } from 'lucide-vue-next';
import axios from 'axios';
import { useAuthStore } from '@/stores/auth';
import { useRouter } from 'vue-router';
const router = useRouter();
const authStore = useAuthStore();
const User = authStore.user;

const emit = defineEmits(['notificationRead', 'notificationCleared']);

async function readNotification(id) {
    try {
        await axios.patch(`http://localhost:3000/notifications/${id}`, {
            read: 'true'
        });
        emit('notificationRead', id);
    } catch (error) {
        console.error('Error marking notification as read:', error);
    }
}

async function consultar(type, id) {
    if (type === 'Troca de Turno') {
        await readNotification(id);
        if(User.type === 'student') {
            router.push('/students/horario');
        } else {
            router.push('/directors/pedidos-troca');
        }
    }
    else if (type == 'Troca de Sala') {
        await readNotification(id);
        if(User.type === 'student') {
            router.push('/students/consultar-turnos');
        }
    }
    else if (type == 'Publicação de Horário') {
        await readNotification(id);
        if(User.type === 'student') {
            router.push('/students/horario');
        }
    }
    else if(type == 'Sistema') {
        await readNotification(id);
        if(User.type === 'student') {
            router.push('/students/home');
        }
        else if(User.type === 'director') {
            router.push('/directors/home');
        }
    }
    else {
        await readNotification(id);
    }
}

async function clearNotification(id) {
    try {
        await axios.delete(`http://localhost:3000/notifications/${id}`);
        emit('notificationCleared', id);
    } catch (error) {
        console.error('Error clearing notification:', error);
    }
}

defineProps({
    id: {
        type: String,
        required: true
    },
    title: {
        type: String,
        required: true
    },
    message: {
        type: String,
        required: true
    },
    date: {
        type: String,
        required: true
    },
    type: {
        type: String,
        required: true
    },
    read: {
        type: Boolean,
        required: true
    }
});
</script>

<style scoped>
@media (min-width: 400px) {
    .xs\:flex-row {
        flex-direction: row;
    }
    .xs\:space-x-2 > :not([hidden]) ~ :not([hidden]) {
        --tw-space-x-reverse: 0;
        margin-right: calc(0.5rem * var(--tw-space-x-reverse));
        margin-left: calc(0.5rem * calc(1 - var(--tw-space-x-reverse)));
    }
    .xs\:space-y-0 > :not([hidden]) ~ :not([hidden]) {
        --tw-space-y-reverse: 0;
        margin-top: calc(0rem * calc(1 - var(--tw-space-y-reverse)));
        margin-bottom: calc(0rem * var(--tw-space-y-reverse));
    }
    .xs\:block {
        display: block;
    }
}
</style>