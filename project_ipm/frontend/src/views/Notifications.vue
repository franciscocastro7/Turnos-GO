<template>
    <div class="h-full min-h-screen bg-background_gray">
        <div class="w-full">
            <h1 class="px-20 xl:px-8 py-8 md:py-7 xl:py-10 text-sm md:text-lg font-poppins font-semibold text-white">
                <span class="font-poppins text-white/50">Principal /</span>
                Notificações
            </h1>
            <h2
                class="text-white text-xl md:text-3xl px-10 md:px-20 pt-5 font-semibold underline underline-offset-3"
            >
                Notificações Pendentes
            </h2>
            <div class="py-14">
                <div v-if="unreadNotifications.length > 0" class="relative">
                    <Carousel 
                        :items-to-show="itemsToShow" 
                        :snapAlign="'start'" 
                        :transition="500"
                        :class="{'disabled-navigation': unreadNotifications.length < (isLargeScreen ? 3 : 2)}"
                        class="carousel-container"
                    >
                        <Slide
                        v-for="notification in unreadNotifications"
                        :key="notification.id"
                        class="carousel-slide"
                        >
                            <div class="px-6 md:px-10">
                                <notificationsCard
                                :id="notification.id"
                                :title="notification.title"
                                :message="notification.message"
                                :date="formatDate(notification.date)"
                                :type="notification.type"
                                :read=false
                                @notificationRead="handleNotificationRead"
                                />
                            </div>
                        </Slide>
                        
                        <template #addons>
                            <Navigation v-if="!isMobile" />
                            <Pagination v-if="isMobile" />
                        </template>
                    </Carousel>
                </div>
                <div
                v-else
                class="flex items-center justify-center p-8 bg-background_gray rounded-lg"
                >
                    <p class="text-white/70 text-lg">
                        Não existem notificações pendentes
                    </p>
                </div>
            </div>
        </div>

        <div class="w-full">
        <h2
            class="text-white text-xl md:text-3xl px-10 md:px-20 pt-2 font-semibold underline underline-offset-3"
        >
            Notificações Anteriores
        </h2>
        <div class="py-16">
            <div v-if="readNotifications.length > 0" class="relative">
                <Carousel 
                    :items-to-show="itemsToShow" 
                    :snapAlign="'start'"
                    :transition="500"
                    :class="{'disabled-navigation': readNotifications.length < (isLargeScreen ? 3 : 2)}"
                    class="carousel-container"
                >
                    <Slide
                    v-for="notification in readNotifications"
                    :key="notification.id"
                    class="carousel-slide"
                    >
                        <div class="px-6 md:px-10">
                            <notificationsCard
                            :id="notification.id"
                            :title="notification.title"
                            :message="notification.message"
                            :date="formatDate(notification.date)"
                            :type="notification.type"
                            :read=true
                            @notificationCleared="handleNotificationCleared"
                            />
                        </div>
                    </Slide>
                    
                    <template #addons>
                        <Navigation v-if="!isMobile" />
                        <Pagination v-if="isMobile" />
                    </template>
                </Carousel>
            </div>
            <div
            v-else
            class="flex items-center justify-center p-8 bg-background_gray rounded-lg"
            >
                <p class="text-white/70 text-lg">
                    Não existem notificações anteriores
                </p>
            </div>
        </div>
        </div>
    </div>
</template>

<script setup>
import notificationsCard from "@/components/notificationsCard.vue";
import { useAuthStore } from "@/stores/auth";
import { ref, onMounted, onUnmounted, computed } from "vue";
import axios from "axios";
import { Carousel, Navigation, Pagination, Slide } from "vue3-carousel";
import "vue3-carousel/dist/carousel.css";

const authStore = useAuthStore();
const user = authStore.user;

const notifications = ref([]);
const unreadNotifications = ref([]);
const readNotifications = ref([]);
const windowWidth = ref(window.innerWidth);

const handleResize = () => {
    windowWidth.value = window.innerWidth;
};

const isLargeScreen = computed(() => {
    return windowWidth.value >= 1500;
});

const isMobile = computed(() => {
    return windowWidth.value < 768;
});

const itemsToShow = computed(() => {
    return isLargeScreen.value ? 2 : 1;
});

function formatDate(dateString) {
    const now = new Date();
    const date = new Date(dateString);
    const diff = now - date;

    const seconds = Math.floor(diff / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);
    const months = Math.floor(days / 30);
    const years = Math.floor(days / 365);

    if (years > 0) return years === 1 ? "1 ano atrás" : `${years} anos atrás`;
    if (months > 0) return months === 1 ? "1 mês atrás" : `${months} meses atrás`;
    if (days > 0) return days === 1 ? "1 dia atrás" : `${days} dias atrás`;
    if (hours > 0) return hours === 1 ? "1 hora atrás" : `${hours} horas atrás`;
    if (minutes > 0)
        return minutes === 1 ? "1 minuto atrás" : `${minutes} minutos atrás`;
    if (seconds > 0)
        return seconds === 1 ? "1 segundo atrás" : `${seconds} segundos atrás`;
    return "agora mesmo";
}

async function getNotifications() {
    try {
        const response = await axios.get(
        `http://localhost:3000/notifications?userId=${user.email}`
        );
        if (response.status === 200) {
            notifications.value = response.data;
            unreadNotifications.value = notifications.value.filter((n) => n.read === "false");
            readNotifications.value = notifications.value.filter((n) => n.read === "true");
        }
    } catch (error) {
        console.error("Failed to fetch notifications:", error);
    }
}

function handleNotificationRead(id) {
    const notif = unreadNotifications.value.find((n) => n.id === id);
    if (notif) {
        notif.read = true;
        unreadNotifications.value = unreadNotifications.value.filter(
        (n) => n.id !== id
        );
        readNotifications.value.unshift(notif);
    }
}

function handleNotificationCleared(id) {
    unreadNotifications.value = unreadNotifications.value.filter(
        (n) => n.id !== id
    );
    readNotifications.value = readNotifications.value.filter((n) => n.id !== id);
}

onMounted(() => {
    getNotifications();
    window.addEventListener('resize', handleResize);
});

// Make sure to remove event listener when component is unmounted
onUnmounted(() => {
    window.removeEventListener('resize', handleResize);
});
</script>

<style scoped>
:deep(.carousel__prev),
:deep(.carousel__next) {
    background-color: #EB5E28;
    border-radius: 50%;
    width: 32px;
    height: 32px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #FFF;
    cursor: pointer;
    transition: all 0.3s;
}

:deep(.carousel__prev) {
    left: 50px;
}

:deep(.carousel__next) {
    right: 50px;
}

@media (min-width: 1024px) {
    :deep(.carousel__prev) {
        left: 80px;
    }

    :deep(.carousel__next) {
        right: 80px;
    }
}

:deep(.carousel__prev--disabled),
:deep(.carousel__next--disabled) {
    opacity: 0.6;
    cursor: default;
}

/* Estilo para carrosséis com menos de 3 itens */
.disabled-navigation :deep(.carousel__prev),
.disabled-navigation :deep(.carousel__next) {
    opacity: 0.6;
    cursor: default;
    pointer-events: none;
}

/* Estilização para os slides do carrossel */
.carousel-container {
    margin-bottom: 40px;
    position: relative;
}

.carousel-slide {
    padding: 0;
}

:deep(.carousel__viewport) {
    padding: 0;
}

/* Estilo para os indicadores de página (bolinhas) em dispositivos móveis */
:deep(.carousel__pagination) {
    position: absolute;
    bottom: -25px;
    left: 50;
    right: 0;
    display: flex;
    justify-content: center;
    padding: 0;
    margin: 0;
}

:deep(.carousel__pagination-button) {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background-color: rgba(235, 94, 40, 0.3);
    margin: 0 3px;
}

:deep(.carousel__pagination-button--active) {
    background-color: #EB5E28;
}
</style>