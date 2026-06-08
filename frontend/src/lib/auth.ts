import { api } from "./api.ts"

type LoginInput = {
  username: string
  password: string
}

type RegisterInput = LoginInput & {
  email?: string
}

export async function login({ username, password }: LoginInput) {
  const res = await api.post('/token/', {
    username,
    password,
  })

  const { access, refresh } = res.data

  sessionStorage.setItem('accessToken', access)
  sessionStorage.setItem('refreshToken', refresh)

  return res.data
}

export async function register({ username, password, email }: RegisterInput) {
  const res = await api.post('/register/', {
    username,
    password,
    email,
  })

  return res.data
}

export function logout() {
  sessionStorage.removeItem("accessToken")
  sessionStorage.removeItem("refreshToken")
}
