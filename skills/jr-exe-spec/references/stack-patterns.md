# Stack Patterns Reference

Patrones de convención y estructura por stack. Consultar durante la ejecución del spec para tomar decisiones de código consistentes con el ecosistema.

---

## JavaScript / TypeScript

### Estructura de archivos
```
src/
├── components/     # Componentes UI reutilizables
├── hooks/          # Custom hooks (use*.ts)
├── services/       # Lógica de negocio / llamadas a APIs
├── utils/          # Funciones puras utilitarias
├── types/          # Interfaces y tipos globales (*.types.ts)
├── store/          # Estado global
└── constants/      # Constantes y enums
```

### Convenciones
- **Archivos**: `kebab-case.ts` para utils/services, `PascalCase.tsx` para componentes
- **Exports**: Named exports por defecto; default export solo en componentes de página
- **Tipos**: Interfaces para objetos extendibles, `type` para unions y primitivos
- **Imports**: Absolutos con alias (`@/components/...`) si el proyecto los tiene configurados

### Patrones comunes
```typescript
// Servicio con manejo de errores
export async function fetchData<T>(url: string): Promise<T> {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.json();
}

// Hook personalizado
export function useFeature(id: string) {
  const [data, setData] = useState<FeatureType | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  // ...
  return { data, loading, error };
}
```

---

## React

### Estructura de componentes
```tsx
// Orden interno de un componente
1. Imports
2. Types/interfaces locales
3. Constantes locales
4. Componente (hooks → derivados → handlers → return JSX)
5. Subcomponentes pequeños si aplica
6. Export
```

### Convenciones
- Componentes funcionales siempre, sin clases
- Props con interfaz explícita: `interface ButtonProps { label: string; onClick: () => void }`
- Evitar `any`; usar `unknown` si el tipo es dinámico
- `key` en listas siempre con ID real, nunca con índice si la lista es mutable

### Patrones comunes
```tsx
// Componente con variantes
interface CardProps {
  variant?: 'default' | 'outlined' | 'ghost';
  children: React.ReactNode;
}

export function Card({ variant = 'default', children }: CardProps) {
  return <div className={styles[variant]}>{children}</div>;
}
```

---

## Next.js

### Estructura (App Router)
```
app/
├── (routes)/
│   └── feature/
│       ├── page.tsx          # Server Component por defecto
│       ├── layout.tsx
│       └── _components/      # Componentes privados de la ruta
├── api/
│   └── feature/
│       └── route.ts          # Route Handlers
└── globals.css

lib/                          # Utilidades del servidor
components/                   # Componentes compartidos
```

### Convenciones
- `page.tsx` y `layout.tsx` son Server Components por defecto
- `'use client'` solo cuando se necesitan hooks o eventos del browser
- Data fetching en Server Components con `fetch()` nativo (cacheado automáticamente)
- Route Handlers en `app/api/.../route.ts`, exportando funciones `GET`, `POST`, etc.
- Variables de entorno: `NEXT_PUBLIC_*` para cliente, sin prefijo para servidor

### Patrones comunes
```typescript
// Route Handler (app/api/feature/route.ts)
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  try {
    const data = await getFeatureData();
    return NextResponse.json(data);
  } catch (error) {
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

// Server Action
'use server';
export async function createFeature(formData: FormData) {
  const name = formData.get('name') as string;
  // validar, persistir, revalidar
  revalidatePath('/feature');
}
```

---

## Vue 3

### Estructura
```
src/
├── components/     # PascalCase.vue
├── composables/    # use*.ts
├── views/          # Páginas/rutas
├── stores/         # Pinia stores
├── router/
└── types/
```

### Convenciones
- Composition API con `<script setup lang="ts">` siempre
- Props con `defineProps<{ ... }>()`; emits con `defineEmits<{ ... }>()`
- Composables en `composables/use*.ts` siguiendo el patrón de Vue
- Stores con Pinia: `defineStore('name', () => { ... })` (composition style)

### Patrones comunes
```vue
<script setup lang="ts">
interface Props {
  title: string;
  count?: number;
}

const props = withDefaults(defineProps<Props>(), { count: 0 });
const emit = defineEmits<{ update: [value: number] }>();

const doubled = computed(() => props.count * 2);
</script>
```

---

## TanStack (Query / Router / Table)

### TanStack Query
```typescript
// Query key factory (mantener en archivo de keys)
export const featureKeys = {
  all: ['features'] as const,
  list: () => [...featureKeys.all, 'list'] as const,
  detail: (id: string) => [...featureKeys.all, 'detail', id] as const,
};

// useQuery
const { data, isLoading, error } = useQuery({
  queryKey: featureKeys.detail(id),
  queryFn: () => fetchFeature(id),
  staleTime: 5 * 60 * 1000,
});

// useMutation con invalidación
const mutation = useMutation({
  mutationFn: createFeature,
  onSuccess: () => queryClient.invalidateQueries({ queryKey: featureKeys.all }),
});
```

---

## Node.js (Express / Fastify)

### Estructura
```
src/
├── routes/         # Definición de rutas
├── controllers/    # Handlers de requests
├── services/       # Lógica de negocio
├── middleware/     # Middlewares
├── models/         # Modelos de datos
├── utils/
└── config/
```

### Convenciones
- Separación estricta: routes → controllers → services (sin saltar capas)
- Middleware de errores centralizado al final del app
- Variables de entorno validadas al inicio con `zod` o similar
- Nunca lógica de negocio en routes o controllers

### Patrones comunes
```typescript
// Controller
export const getFeature = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const data = await featureService.getById(req.params.id);
    res.json(data);
  } catch (error) {
    next(error);
  }
};

// Middleware de error centralizado
export function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  console.error(err.stack);
  res.status(500).json({ error: err.message });
}
```

---

## PHP / Laravel

### Estructura
```
app/
├── Http/
│   ├── Controllers/    # Un controller por recurso
│   ├── Requests/       # Form Requests para validación
│   └── Resources/      # API Resources para transformación
├── Models/
├── Services/           # Lógica de negocio (no en controllers)
├── Repositories/       # Acceso a datos (opcional)
└── Providers/
```

### Convenciones
- Validación en Form Requests, nunca inline en controllers
- Lógica de negocio en Services, no en Models ni Controllers
- Eloquent relationships definidas en el Model
- API responses a través de API Resources
- Eventos y Listeners para side effects

### Patrones comunes
```php
// Service
class FeatureService
{
    public function create(array $data): Feature
    {
        return DB::transaction(function () use ($data) {
            $feature = Feature::create($data);
            event(new FeatureCreated($feature));
            return $feature;
        });
    }
}

// Controller (thin)
public function store(StoreFeatureRequest $request): FeatureResource
{
    $feature = $this->featureService->create($request->validated());
    return new FeatureResource($feature);
}
```

---

## WordPress

### Estructura de un plugin/tema custom
```
plugin-name/
├── plugin-name.php       # Header y bootstrap
├── includes/
│   ├── class-*.php       # Clases principales
│   └── functions-*.php   # Funciones auxiliares
├── admin/                # Código del admin
├── public/               # Código del frontend
└── assets/
    ├── js/
    ├── css/
    └── images/
```

### Convenciones
- Prefijo único en todas las funciones: `miplugin_nombre_funcion()`
- Hooks siempre sobre `init` o hooks específicos, nunca código suelto en root
- Sanitizar inputs con `sanitize_text_field()`, `absint()`, etc.
- Escapar outputs con `esc_html()`, `esc_url()`, `esc_attr()`
- Nonces para todas las acciones de formularios y AJAX

### Patrones comunes
```php
// Registrar hook
add_action('init', 'miplugin_register_post_type');

function miplugin_register_post_type(): void {
    register_post_type('mi_tipo', [
        'labels'   => ['name' => __('Mi Tipo', 'miplugin')],
        'public'   => true,
        'supports' => ['title', 'editor', 'thumbnail'],
    ]);
}

// AJAX con nonce
add_action('wp_ajax_miplugin_action', 'miplugin_handle_ajax');
function miplugin_handle_ajax(): void {
    check_ajax_referer('miplugin_nonce', 'nonce');
    $data = sanitize_text_field($_POST['data'] ?? '');
    wp_send_json_success(['result' => $data]);
}
```

---

## Shopify (Liquid / App)

### Temas (Liquid)
```
sections/       # Secciones configurables desde el editor
snippets/       # Fragmentos reutilizables
layout/         # Layouts base (theme.liquid)
templates/      # Plantillas por tipo de página
assets/         # JS, CSS, imágenes
config/         # settings_schema.json, settings_data.json
locales/        # Traducciones
```

### Convenciones Liquid
- Lógica mínima en templates; usar snippets para reutilización
- Usar `{{ variable | escape }}` para outputs de usuario
- Settings del tema via `{{ settings.mi_setting }}`
- JS en `assets/` con `{{ 'mi-script.js' | asset_url | script_tag }}`

### Apps Shopify (Node/React)
- Shopify CLI para scaffolding
- Autenticación con `@shopify/shopify-api`
- Webhooks verificados siempre con HMAC
- Embedded App Bridge para UI dentro del admin

---

## CSS / Sass / Tailwind CSS

### Sass
```scss
// Estructura
styles/
├── _variables.scss
├── _mixins.scss
├── _reset.scss
├── components/
│   └── _button.scss
└── main.scss   // Solo imports con @use

// Convenciones
// BEM naming: .block__element--modifier
// Variables con $ para valores reutilizables
// Mixins para patrones repetitivos con parámetros
```

### Tailwind CSS
- Clases utilitarias directamente en markup; evitar `@apply` excepto para componentes muy repetidos
- Variantes responsivas: `sm:`, `md:`, `lg:`, `xl:`
- Variantes de estado: `hover:`, `focus:`, `disabled:`
- Clases personalizadas en `tailwind.config.js` bajo `theme.extend`
- No mezclar Tailwind con CSS modules en el mismo componente

---

## Webpack / Vite

### Vite
- Config en `vite.config.ts`
- Alias con `resolve.alias`: `{ '@': path.resolve(__dirname, 'src') }`
- Variables de entorno en `.env`, `.env.local`, `.env.production`
- Plugins en array `plugins: []`, respetar los ya instalados

### Webpack
- Config en `webpack.config.js` o por entorno (`webpack.dev.js`, `webpack.prod.js`)
- Loaders en `module.rules`, plugins en `plugins[]`
- Source maps en dev (`eval-source-map`), sin source maps en prod o `source-map`

---

## Docker

### Estructura
```
Dockerfile              # Imagen principal
docker-compose.yml      # Servicios locales
docker-compose.prod.yml # Overrides de producción
.dockerignore
```

### Convenciones
```dockerfile
# Multi-stage build (preferido para producción)
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

- Variables de entorno con `ENV` en Dockerfile solo para defaults no sensibles
- Secrets y configs en `docker-compose.yml` via `environment:` o `env_file:`
- Nunca copiar `.env` con secrets reales en la imagen; usar `.dockerignore`
- Healthchecks definidos en `docker-compose.yml` para servicios críticos
