import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', () => {
  const isAuthenticated = ref(false)
  const user = ref(null)

  const isLoggedIn = computed(() => isAuthenticated.value)
  const currentUser = computed(() => user.value)

  function login(userData) {
    isAuthenticated.value = true
    user.value = userData
    localStorage.setItem('userData', JSON.stringify(userData))
  }

  function logout() {
    isAuthenticated.value = false
    user.value = null
    localStorage.removeItem('userData')
  }

  function initializeAuth() {
    const savedUserData = localStorage.getItem('userData')
    
    if (savedUserData) {
      user.value = JSON.parse(savedUserData)
      isAuthenticated.value = true
    }
  }

  function isStudent() {
    return user.value && user.value.type === 'student'
  }

  return {
    isAuthenticated,
    isStudent,
    user,
    isLoggedIn,
    currentUser,
    login,
    logout,
    initializeAuth
  }
})
