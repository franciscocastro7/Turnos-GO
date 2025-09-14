import { useAuthStore } from '@/stores/auth'

export default function authmiddleware(to, from, next) {
    const authStore = useAuthStore()
    
    if (!authStore.isAuthenticated) {
        authStore.initializeAuth()
    }

    if (to.path === '/') {
        if (authStore.isLoggedIn) {
            const redirectPath = authStore.user?.type === 'student' ? 'inicio-aluno' : 'inicio-diretor'
            return next({ name: redirectPath })
        }
        return next()
    }

    if (to.meta.type && authStore.user?.type !== to.meta.type) {
        if(authStore.user?.type === 'student') {
            return next({ name: 'inicio-aluno' })
        }
        if(authStore.user?.type === 'director') {
            return next({ name: 'inicio-diretor' })
        }
    }

    if (!authStore.isLoggedIn) {
        return next({ name: 'login' })
    }

    return next()
}