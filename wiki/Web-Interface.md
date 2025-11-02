# Web Interface Guide

Complete guide to the React/TypeScript web interface for Security Sentinel.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Technology Stack](#technology-stack)
- [Component Structure](#component-structure)
- [State Management](#state-management)
- [API Integration](#api-integration)
- [Styling and UI](#styling-and-ui)
- [Build and Deployment](#build-and-deployment)
- [Browser Compatibility](#browser-compatibility)

---

## Architecture Overview

### Application Structure

```
src/
├── App.tsx                 # Main application component
├── index.tsx              # Entry point
├── components/            # React components
│   ├── Dashboard.tsx      # Main dashboard
│   ├── NetworkMonitor.tsx # Network view
│   ├── ThreatProtection.tsx # Security view
│   ├── AIAssistant.tsx    # AI chat interface
│   └── Sidebar.tsx        # Navigation sidebar
├── services/              # API services
│   ├── geminiService.ts   # Gemini AI integration
│   └── api.ts            # Backend API client
├── types.ts              # TypeScript type definitions
├── constants.ts          # Application constants
└── index.css            # Global styles
```

### Component Hierarchy

```
App
├── Sidebar
│   ├── Navigation Links
│   └── User Profile
├── Dashboard
│   ├── SystemMetrics
│   ├── ThreatLevel
│   ├── ActivityCharts
│   └── RecentEvents
├── NetworkMonitor
│   ├── ConnectionList
│   ├── TrafficGraph
│   └── BlockedIPs
├── ThreatProtection
│   ├── ThreatTimeline
│   ├── SecurityStatus
│   └── ResponseActions
└── AIAssistant
    ├── ChatHistory
    ├── MessageInput
    └── StreamingResponse
```

---

## Technology Stack

### Core Libraries

**React 19**:
```json
{
  "react": "^19.1.0",
  "react-dom": "^19.1.0"
}
```

**TypeScript 5.9**:
```json
{
  "typescript": "~5.9.2"
}
```

**Build Tool - Vite 7**:
```json
{
  "vite": "^7.0.0"
}
```

### UI Libraries

**Recharts** (Data Visualization):
```typescript
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip } from 'recharts';
```

**Lucide React** (Icons):
```typescript
import { Shield, Activity, Network, AlertTriangle } from 'lucide-react';
```

### AI Integration

**Google Gemini SDK**:
```typescript
import { GoogleGenerativeAI } from '@google/generative-ai';
```

---

## Component Structure

### Dashboard Component

```typescript
// components/Dashboard.tsx
import React, { useState, useEffect } from 'react';
import { Activity, Cpu, HardDrive, Network } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

interface SystemMetrics {
  cpu: number;
  memory: number;
  connections: number;
  threatLevel: 'low' | 'medium' | 'high';
}

interface DashboardProps {
  refreshInterval?: number;
}

export const Dashboard: React.FC<DashboardProps> = ({ refreshInterval = 5000 }) => {
  const [metrics, setMetrics] = useState<SystemMetrics>({
    cpu: 0,
    memory: 0,
    connections: 0,
    threatLevel: 'low'
  });
  
  const [history, setHistory] = useState<any[]>([]);
  
  useEffect(() => {
    const fetchMetrics = async () => {
      try {
        // Fetch from backend or use mock data
        const response = await fetch('/api/metrics');
        const data = await response.json();
        setMetrics(data);
        
        // Update history for charts
        setHistory(prev => [
          ...prev.slice(-20),
          { time: new Date().toLocaleTimeString(), ...data }
        ]);
      } catch (error) {
        console.error('Failed to fetch metrics:', error);
      }
    };
    
    fetchMetrics();
    const interval = setInterval(fetchMetrics, refreshInterval);
    
    return () => clearInterval(interval);
  }, [refreshInterval]);
  
  return (
    <div className="dashboard p-6">
      <h1 className="text-3xl font-bold mb-6">Security Dashboard</h1>
      
      {/* Metric Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <MetricCard
          title="CPU Usage"
          value={`${metrics.cpu}%`}
          icon={<Cpu />}
          color="blue"
        />
        <MetricCard
          title="Memory"
          value={`${metrics.memory}%`}
          icon={<HardDrive />}
          color="green"
        />
        <MetricCard
          title="Connections"
          value={metrics.connections}
          icon={<Network />}
          color="purple"
        />
        <MetricCard
          title="Threat Level"
          value={metrics.threatLevel.toUpperCase()}
          icon={<Activity />}
          color={getThreatColor(metrics.threatLevel)}
        />
      </div>
      
      {/* Activity Chart */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-4">
        <h2 className="text-xl font-semibold mb-4">System Activity</h2>
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={history}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="time" />
            <YAxis />
            <Tooltip />
            <Line type="monotone" dataKey="cpu" stroke="#3b82f6" name="CPU %" />
            <Line type="monotone" dataKey="memory" stroke="#10b981" name="Memory %" />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
};

const MetricCard: React.FC<{
  title: string;
  value: string | number;
  icon: React.ReactNode;
  color: string;
}> = ({ title, value, icon, color }) => (
  <div className={`bg-white dark:bg-gray-800 rounded-lg shadow p-4 border-l-4 border-${color}-500`}>
    <div className="flex items-center justify-between">
      <div>
        <p className="text-gray-600 dark:text-gray-400 text-sm">{title}</p>
        <p className="text-2xl font-bold mt-1">{value}</p>
      </div>
      <div className={`text-${color}-500`}>
        {icon}
      </div>
    </div>
  </div>
);
```

### AI Assistant Component

```typescript
// components/AIAssistant.tsx
import React, { useState, useRef, useEffect } from 'react';
import { Send, Bot, User } from 'lucide-react';
import { geminiService } from '../services/geminiService';

interface Message {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
}

export const AIAssistant: React.FC = () => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };
  
  useEffect(scrollToBottom, [messages]);
  
  const handleSend = async () => {
    if (!input.trim() || isLoading) return;
    
    const userMessage: Message = {
      id: Date.now().toString(),
      role: 'user',
      content: input,
      timestamp: new Date()
    };
    
    setMessages(prev => [...prev, userMessage]);
    setInput('');
    setIsLoading(true);
    
    try {
      const response = await geminiService.sendMessage(input);
      
      const aiMessage: Message = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: response,
        timestamp: new Date()
      };
      
      setMessages(prev => [...prev, aiMessage]);
    } catch (error) {
      console.error('AI request failed:', error);
      const errorMessage: Message = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: 'Sorry, I encountered an error. Please try again.',
        timestamp: new Date()
      };
      setMessages(prev => [...prev, errorMessage]);
    } finally {
      setIsLoading(false);
    }
  };
  
  return (
    <div className="ai-assistant h-screen flex flex-col">
      <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white p-4">
        <h1 className="text-2xl font-bold flex items-center">
          <Bot className="mr-2" /> AI Security Assistant
        </h1>
        <p className="text-sm opacity-90">Powered by Google Gemini</p>
      </div>
      
      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.length === 0 && (
          <div className="text-center text-gray-500 mt-10">
            <Bot size={48} className="mx-auto mb-4 opacity-50" />
            <p>Start a conversation about your system security</p>
          </div>
        )}
        
        {messages.map(message => (
          <div
            key={message.id}
            className={`flex ${message.role === 'user' ? 'justify-end' : 'justify-start'}`}
          >
            <div
              className={`max-w-[70%] rounded-lg p-3 ${
                message.role === 'user'
                  ? 'bg-blue-600 text-white'
                  : 'bg-gray-200 dark:bg-gray-700 text-gray-900 dark:text-white'
              }`}
            >
              <div className="flex items-center mb-1">
                {message.role === 'user' ? <User size={16} /> : <Bot size={16} />}
                <span className="ml-2 text-xs opacity-75">
                  {message.timestamp.toLocaleTimeString()}
                </span>
              </div>
              <p className="whitespace-pre-wrap">{message.content}</p>
            </div>
          </div>
        ))}
        
        {isLoading && (
          <div className="flex justify-start">
            <div className="bg-gray-200 dark:bg-gray-700 rounded-lg p-3">
              <div className="flex items-center space-x-2">
                <div className="w-2 h-2 bg-gray-600 rounded-full animate-bounce" />
                <div className="w-2 h-2 bg-gray-600 rounded-full animate-bounce delay-100" />
                <div className="w-2 h-2 bg-gray-600 rounded-full animate-bounce delay-200" />
              </div>
            </div>
          </div>
        )}
        
        <div ref={messagesEndRef} />
      </div>
      
      {/* Input */}
      <div className="border-t dark:border-gray-700 p-4">
        <div className="flex space-x-2">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSend()}
            placeholder="Ask about security threats, network activity..."
            className="flex-1 border dark:border-gray-600 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-800 dark:text-white"
            disabled={isLoading}
          />
          <button
            onClick={handleSend}
            disabled={!input.trim() || isLoading}
            className="bg-blue-600 text-white rounded-lg px-6 py-2 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Send size={20} />
          </button>
        </div>
      </div>
    </div>
  );
};
```

---

## State Management

### Using React Hooks

```typescript
// Custom hook for security monitoring
function useSecurityMonitor(interval: number = 5000) {
  const [data, setData] = useState<SecurityData | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch('/api/security/status');
        const json = await response.json();
        setData(json);
        setError(null);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Unknown error');
      } finally {
        setIsLoading(false);
      }
    };
    
    fetchData();
    const timer = setInterval(fetchData, interval);
    
    return () => clearInterval(timer);
  }, [interval]);
  
  return { data, error, isLoading };
}

// Usage in component
const Dashboard: React.FC = () => {
  const { data, error, isLoading } = useSecurityMonitor(5000);
  
  if (isLoading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;
  
  return <DashboardView data={data} />;
};
```

---

## API Integration

### Gemini Service

```typescript
// services/geminiService.ts
import { GoogleGenerativeAI } from '@google/generative-ai';

class GeminiService {
  private genAI: GoogleGenerativeAI;
  private model: any;
  
  constructor() {
    const apiKey = import.meta.env.VITE_GEMINI_API_KEY || process.env.GEMINI_API_KEY;
    if (!apiKey) {
      throw new Error('Gemini API key not configured');
    }
    
    this.genAI = new GoogleGenerativeAI(apiKey);
    this.model = this.genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });
  }
  
  async sendMessage(message: string): Promise<string> {
    try {
      const result = await this.model.generateContent(message);
      const response = await result.response;
      return response.text();
    } catch (error) {
      console.error('Gemini API error:', error);
      throw new Error('Failed to get AI response');
    }
  }
  
  async sendMessageStream(
    message: string,
    onChunk: (chunk: string) => void
  ): Promise<void> {
    try {
      const result = await this.model.generateContentStream(message);
      
      for await (const chunk of result.stream) {
        const chunkText = chunk.text();
        onChunk(chunkText);
      }
    } catch (error) {
      console.error('Gemini streaming error:', error);
      throw new Error('Failed to stream AI response');
    }
  }
}

export const geminiService = new GeminiService();
```

---

## Styling and UI

### Tailwind CSS

**Configuration** (`tailwind.config.js`):
```javascript
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#3b82f6',
        secondary: '#8b5cf6',
        danger: '#ef4444',
        success: '#10b981',
        warning: '#f59e0b',
      },
    },
  },
  plugins: [],
  darkMode: 'class',
};
```

**Dark Mode Support**:
```typescript
function useDarkMode() {
  const [isDark, setIsDark] = useState(() => {
    return localStorage.getItem('theme') === 'dark';
  });
  
  useEffect(() => {
    if (isDark) {
      document.documentElement.classList.add('dark');
      localStorage.setItem('theme', 'dark');
    } else {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('theme', 'light');
    }
  }, [isDark]);
  
  return [isDark, setIsDark] as const;
}
```

---

## Build and Deployment

### Development Build

```bash
# Start dev server
npm run dev

# Server runs on http://localhost:5173
# Hot reload enabled
```

### Production Build

```bash
# Build for production
npm run build

# Output: dist/
# - Optimized bundles
# - Minified assets
# - Source maps (optional)
```

### Environment Variables

**.env.local**:
```env
VITE_GEMINI_API_KEY=your_api_key_here
VITE_API_URL=http://localhost:3000
VITE_ENABLE_DEBUG=false
```

### Deployment Options

**GitHub Pages**:
```bash
npm run build
npm run deploy
```

**Netlify/Vercel**:
- Connect repository
- Set build command: `npm run build`
- Set publish directory: `dist`
- Add environment variables

---

## Browser Compatibility

### Supported Browsers

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

### Polyfills

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import legacy from '@vitejs/plugin-legacy';

export default defineConfig({
  plugins: [
    react(),
    legacy({
      targets: ['defaults', 'not IE 11']
    })
  ]
});
```

---

## Performance Optimization

### Code Splitting

```typescript
import { lazy, Suspense } from 'react';

const Dashboard = lazy(() => import('./components/Dashboard'));
const AIAssistant = lazy(() => import('./components/AIAssistant'));

function App() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/ai" element={<AIAssistant />} />
      </Routes>
    </Suspense>
  );
}
```

### Memoization

```typescript
import { memo, useMemo } from 'react';

const MetricCard = memo(({ title, value, icon }: MetricCardProps) => {
  return (
    <div className="metric-card">
      {/* ... */}
    </div>
  );
});

function Dashboard() {
  const expensiveCalculation = useMemo(() => {
    return computeComplexMetrics(data);
  }, [data]);
  
  return <div>{expensiveCalculation}</div>;
}
```

---

[🏠 Back to Home](Home.md) | [🏗️ Architecture](Architecture-Overview.md) | [📚 API Reference](API-Reference.md)
