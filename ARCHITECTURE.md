# Project Architecture Diagram

## High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Frontend Application                     │
│                      (React 19 + TypeScript)                     │
└─────────────────────────────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
         ┌──────────▼──────────┐   ┌─────────▼──────────┐
         │    State Management │   │  Styling & Layout  │
         │     (Zustand)       │   │  (Tailwind CSS)    │
         └─────────────────────┘   └────────────────────┘
                    │
    ┌───────────────┼───────────────┐
    │               │               │
┌───▼────┐  ┌──────▼──────┐  ┌────▼────────┐
│ Stores │  │ Components  │  │   Features  │
└────────┘  └─────────────┘  └─────────────┘
```

## Project Structure

```
final-yr-proj/
├── index.tsx                    # Application Entry Point
├── index.html                   # HTML Template
├── index.css                    # Global Styles
├── App.tsx                      # Root Component (Main Layout)
├── store.ts                     # Zustand State Management
├── metadata.json                # Configuration/Metadata
├── vite.config.ts              # Vite Build Configuration
├── tsconfig.json               # TypeScript Configuration
├── package.json                # Dependencies
│
├── components/                  # Reusable UI Components
│   └── ui/
│       └── Button.tsx           # Base Button Component
│
└── features/                    # Feature Modules
    ├── Dashboard.tsx            # Main Contract Dashboard (Kanban Board)
    ├── TenderUpload.tsx         # Tender/Contract Upload Feature
    ├── TenderDetailsModal.tsx   # Contract Details Viewer
    ├── DriverNegotiation.tsx    # Driver Cost Negotiation
    └── TrashModal.tsx           # Deleted Contracts Recovery
```

## Component Hierarchy

```
App.tsx (Root)
│
├── Navbar (Theme Toggle, Tab Navigation)
├── Split View Layout
│   ├── Sidebar Navigation
│   └── Main Content Area
│       │
│       ├── Dashboard Tab
│       │   ├── Dashboard.tsx (Kanban Board)
│       │   │   ├── Column Components
│       │   │   │   ├── Contract Cards
│       │   │   │   │   ├── TenderDetailsModal
│       │   │   │   │   └── DriverNegotiation
│       │   │   │   └── Search & Filter Bar
│       │   │   └── Drag & Drop Context (@dnd-kit)
│       │   │
│       │   ├── TenderDetailsModal.tsx
│       │   │   ├── Bid Details Display
│       │   │   ├── Cost Breakdown
│       │   │   └── Risk Analysis
│       │   │
│       │   ├── DriverNegotiation.tsx
│       │   │   ├── Negotiation Form
│       │   │   └── Cost Adjustment UI
│       │   │
│       │   └── TrashModal.tsx
│       │       ├── Deleted Contracts List
│       │       └── Restore Actions
│       │
│       └── Upload Tab
│           └── TenderUpload.tsx
│               ├── File Drop Zone
│               ├── Contract Upload
│               └── Batch Processing
│
└── Button.tsx (Reusable Component)
```

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Zustand Store                         │
│                  (store.ts)                             │
│                                                         │
│  State:                    Actions:                     │
│  • contracts[]            • addContract()              │
│  • deletedContracts[]     • updateContract()           │
│  • columns[]              • moveContract()             │
│  • theme                  • deleteContract()           │
│  • negotiatingContract    • restoreContract()          │
│  • activeDragId           • toggleTheme()              │
│  • activeColumnId         • etc.                       │
└──────────────────────┬──────────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
    Dashboard     TenderUpload   TrashModal
    (Read)        (Write)        (Restore)
        │              │              │
        └──────────────┼──────────────┘
                       │
                 Contract Updates
```

## Key Technologies Stack

```
Frontend Framework
├── React 19.2.0         (UI Library)
├── TypeScript 5.8       (Type Safety)
└── Vite 6.2.0          (Build Tool)

State Management
└── Zustand 5.0.8       (Lightweight State)

Styling & Animation
├── Tailwind CSS         (Utility-First CSS)
├── Framer Motion 12.23  (Smooth Animations)
└── Lucide React 0.555   (Icons)

Interaction Libraries
├── React Router 7.9     (Routing)
├── @dnd-kit/* 6.3+      (Drag & Drop)
│   ├── @dnd-kit/core
│   ├── @dnd-kit/sortable
│   └── @dnd-kit/utilities
├── react-dropzone 14.3  (File Upload)
└── clsx 2.1.1          (Class Name Utilities)
```

## Feature Descriptions

### 1. **Dashboard (Main Feature)**
- **Type**: Kanban Board
- **Purpose**: Manage contracts through different stages
- **Stages**: Searching → Evaluating → Negotiating → Success
- **Interactions**: 
  - Drag & Drop contracts between columns
  - View contract details
  - Delete/Restore contracts
  - Negotiate driver costs

### 2. **Tender Upload**
- **Purpose**: Import contracts from files
- **Features**:
  - Drag & drop file upload
  - Batch contract processing
  - Data validation

### 3. **Tender Details Modal**
- **Purpose**: Display full contract information
- **Displays**:
  - Bid costs breakdown
  - Route & vehicle details
  - Risk analysis
  - Profit margins

### 4. **Driver Negotiation**
- **Purpose**: Negotiate driver costs for contracts
- **Features**:
  - Cost adjustment forms
  - Real-time calculations

### 5. **Trash/Recycle Bin**
- **Purpose**: Recover deleted contracts
- **Features**:
  - View deleted contracts
  - Restore contracts

## State Management Flow

```
User Interaction
    │
    ▼
Component Event Handler
    │
    ▼
Zustand Store Action
    │
    ├─► Update State
    │
    └─► Component Re-render
        │
        ▼
    Update UI
```

## Responsive Design

```
Split View Layout
├── Resizable Divider
├── Left Sidebar (Collapsible)
└── Main Content Area (Responsive)
    ├── Mobile: Single Column
    ├── Tablet: Stacked Layout
    └── Desktop: Full Split View
```

## Theme System

```
Light Mode (Default)
├── Light Background
├── Dark Text
└── Subtle Shadows

Dark Mode
├── Dark Background
├── Light Text
└── Enhanced Contrast
```

## File Size Summary

| File | Lines | Purpose |
|------|-------|---------|
| Dashboard.tsx | 1104 | Main kanban board logic |
| TenderDetailsModal.tsx | 498 | Contract details display |
| Store.ts | 114 | State management |
| App.tsx | 204 | Root component |

---

## Development Workflow

```
Development
    │
    npm run dev (Vite Dev Server)
    │
    ▼
Build
    │
    npm run build (Production Build)
    │
    ▼
Preview
    │
    npm run preview (Local Preview)
```

---

**Generated**: January 4, 2026
**Framework**: React 19 + TypeScript + Vite
**Key Pattern**: Component-based with Zustand state management
