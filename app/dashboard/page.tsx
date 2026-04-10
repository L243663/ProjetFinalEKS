'use client'
import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'

export default function Dashboard() {
  const router = useRouter()
  const [userId, setUserId] = useState<string | null>(null)

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (!data.user) {
        router.push('/login')
        return
      }
      setUserId(data.user.id)
    })
  }, [router])

  if (!userId) return <div style={{ padding: '2rem' }}>Chargement...</div>

  return (
    <div style={{ maxWidth: '900px', margin: '0 auto', padding: '2rem' }}>
      <h1>⏱ TimeTracker Dashboard</h1>
      <p>Bienvenue dans votre espace de gestion du temps.</p>

      <button
        onClick={async () => {
          await supabase.auth.signOut()
          router.push('/login')
        }}
        style={{
          padding: '0.5rem 1rem',
          background: '#f1f5f9',
          border: 'none',
          borderRadius: '6px'
        }}
      >
        Déconnexion
      </button>
    </div>
  )
}
