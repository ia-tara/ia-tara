import axios from "axios"

function getBaseUrl() {
  if (typeof window === "undefined") {
    return "http://127.0.0.1:8000/api"
  }

  if (import.meta.env.DEV || window.location.port === "4173") {
    const host = window.location.hostname || "127.0.0.1"
    return `${window.location.protocol}//${host}:8000/api`
  }

  return `${window.location.origin}/api`
}

export const api = axios.create()

api.interceptors.request.use((config) => {
  // base URL
  config.baseURL = getBaseUrl()

  // 🔐 access token
  const token = sessionStorage.getItem("accessToken")
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }

  return config
})
