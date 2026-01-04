# Tender Analyzer - Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         TENDER ANALYZER SYSTEM                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                            CLIENT LAYER                                      │
│                     (Frontend - React/Dropzone)                              │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  File Upload Interface (react-dropzone)                                │ │
│  │  - PDF file selection and drop zone                                    │ │
│  │  - Progress tracking UI                                               │ │
│  │  - Real-time streaming updates via SSE                                │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
        ┌─────────────────────────────────────────────────────┐
        │         API LAYER (REST Endpoints)                  │
        │  ┌──────────────────────────────────────────────┐  │
        │  │ POST   /api/analyze        - Upload & process│  │
        │  │ GET    /api/status/{jobId} - Get job status  │  │
        │  │ GET    /api/stream/{jobId} - SSE stream      │  │
        │  └──────────────────────────────────────────────┘  │
        │            (Go HTTP Server - Gorilla Mux)          │
        └─────────────────────────────────────────────────────┘
                                    │
        ┌───────────────┬───────────┼───────────┬──────────────┐
        ▼               ▼           ▼           ▼              ▼
┌──────────────┐ ┌──────────────┐ ┌─────────────────┐ ┌─────────────┐
│  FILE INPUT  │ │ JOB STORE    │ │ TENDER ANALYZER │ │  LOGGING    │
├──────────────┤ ├──────────────┤ ├─────────────────┤ ├─────────────┤
│  PDF Files   │ │  In-Memory   │ │  Core Business  │ │  Real-time  │
│  Uploads/    │ │  Job Status  │ │  Logic          │ │  Streaming  │
│  folder      │ │  Tracking    │ │  - PDF extract  │ │  Logs       │
└──────────────┘ └──────────────┘ │  - AI analysis  │ │  (SSE)      │
                                   │  - Calculate    │ └─────────────┘
                                   │    bid breakdown│
                                   └─────────────────┘
                                    │
        ┌───────────────┬───────────┼───────────┐
        ▼               ▼           ▼
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│ GOOGLE SHEETS    │ │  GOOGLE GEMINI   │ │   PDF LIBRARY    │
│ API              │ │  AI API          │ │  (ledongthuc)    │
├──────────────────┤ ├──────────────────┤ ├──────────────────┤
│ Truck pricing    │ │ AI-powered       │ │ PDF text         │
│ data retrieval   │ │ tender analysis  │ │ extraction       │
└──────────────────┘ └──────────────────┘ └──────────────────┘
        │                   │                     │
        └───────────────────┼─────────────────────┘
                            ▼
        ┌─────────────────────────────────────────┐
        │      CONFIGURATION & CREDENTIALS        │
        ├─────────────────────────────────────────┤
        │ .env                 - Environment vars  │
        │ credentials.json     - Google OAuth      │
        │ go.mod/go.sum        - Go dependencies   │
        │ package.json         - NPM dependencies  │
        └─────────────────────────────────────────┘
                            │
                            ▼
        ┌─────────────────────────────────────────┐
        │         OUTPUT DATA STRUCTURES          │
        ├─────────────────────────────────────────┤
        │ BidBreakdown:                           │
        │ - bid_cost                              │
        │ - vehicle_driver_cost                   │
        │ - fuel_cost                             │
        │ - tolls_and_misc                        │
        │ - profit_margin                         │
        │ - material_type                         │
        └─────────────────────────────────────────┘
```

---

## Component Details

### 1. **Client Layer** (Frontend)
- **Technology**: React + react-dropzone
- **Responsibilities**:
  - PDF file upload interface
  - Progress tracking
  - Real-time streaming updates
  - Display bid breakdown results

### 2. **API Layer** (REST Server)
- **Framework**: Go + Gorilla Mux
- **Port**: Configurable (default from environment)
- **Endpoints**:
  - `POST /api/analyze` - Upload PDF for analysis
  - `GET /api/status/{jobId}` - Check job status
  - `GET /api/stream/{jobId}` - Server-Sent Events stream

### 3. **Business Logic Layer**

#### **TenderAnalyzer**
- Orchestrates the analysis workflow
- Manages interactions with external services

#### **JobStore**
- In-memory job tracking
- Maintains:
  - Job status (pending, processing, completed, failed)
  - Progress percentage
  - Real-time logs
  - Final results

#### **Core Processors**
- **PDF Extraction**: Extracts text from PDF files
- **AI Analysis**: Uses Google Gemini API for intelligent tender analysis
- **Data Calculation**: Computes bid breakdown

### 4. **External Services**

#### **Google Sheets API**
- Retrieves truck pricing data
- Supports:
  - Truck types
  - Weight capacity
  - Rate per km
  - Driver allowances
  - Base hiring charges

#### **Google Gemini API**
- AI-powered tender document analysis
- Extracts:
  - Material requirements
  - Weight specifications
  - Distance information
  - Cost factors

#### **PDF Processing**
- Library: ledongthuc/pdf
- Functionality: Text extraction from PDF documents

### 5. **Data Structures**

```go
Config {
  GeminiAPIKey
  GoogleSheetsID
  CredentialsPath
  ProfitMarginPct
  NegotiationBuffer
}

TruckData {
  TruckType
  MaxWeightTons
  RatePerKm
  DriverAllowanceDay
  BaseHiringCharge
}

BidBreakdown {
  BidCost
  VehicleDriverCost
  FuelCost
  TollsAndMisc
  ProfitMargin
  MaterialType
}

JobStatus {
  JobID
  FileName
  Status
  Progress
  StartTime
  Logs []LogEntry
  Result *BidBreakdown
  Error
}
```

### 6. **File Structure**

```
tender-analyzer/
├── main.go                 # Backend server (Go)
├── go.mod & go.sum         # Go dependencies
├── package.json            # Frontend dependencies
├── node_modules/           # NPM packages
├── .env                    # Environment variables
├── credentials.json        # Google OAuth credentials
├── bid_breakdown.json      # Sample output format
├── tender.pdf              # Sample input
└── uploads/                # PDF upload folder
```

---

## Data Flow

```
1. USER UPLOADS PDF
   │
   ├─→ File saved to uploads/ folder
   │
   ├─→ JobStore creates tracking record
   │
   └─→ Return jobId to client

2. SERVER PROCESSES TENDER
   │
   ├─→ Extract text from PDF
   │   │
   │   └─→ Use Google Sheets API
   │       Fetch truck pricing data
   │
   ├─→ Send to Gemini AI for analysis
   │   │
   │   └─→ Extract: weight, distance, material type
   │
   ├─→ Calculate bid breakdown
   │   ├─→ Vehicle + driver cost
   │   ├─→ Fuel cost
   │   ├─→ Tolls & misc
   │   └─→ Apply profit margin
   │
   └─→ Store results in JobStore

3. CLIENT RECEIVES UPDATES (SSE)
   │
   ├─→ Real-time logs via /api/stream/{jobId}
   │
   ├─→ Poll /api/status/{jobId} for completion
   │
   └─→ Display final BidBreakdown result
```

---

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | React + react-dropzone | UI & file upload |
| **Backend** | Go 1.25.5 | REST API server |
| **Router** | Gorilla Mux | HTTP routing |
| **AI/ML** | Google Gemini API | Document analysis |
| **Data Source** | Google Sheets API | Truck pricing data |
| **PDF Processing** | ledongthuc/pdf | PDF text extraction |
| **Authentication** | Google OAuth 2.0 | Credentials handling |
| **CORS** | rs/cors | Cross-origin handling |
| **UUID** | google/uuid | Unique job tracking |
| **Env Config** | joho/godotenv | Configuration management |

---

## API Contract

### Upload & Analyze
```
POST /api/analyze
Content-Type: multipart/form-data

Body: PDF file

Response:
{
  "jobId": "uuid-string"
}
```

### Get Status
```
GET /api/status/{jobId}

Response:
{
  "jobId": "uuid-string",
  "fileName": "tender.pdf",
  "status": "completed|pending|processing|failed",
  "progress": 75.5,
  "result": {
    "bid_cost": 45000,
    "vehicle_driver_cost": 12000,
    "fuel_cost": 8500,
    "tolls_and_misc": 2500,
    "profit_margin": 22000,
    "material_type": "sand"
  },
  "logs": [
    {
      "timestamp": "2026-01-04T10:30:00Z",
      "message": "Processing started",
      "type": "info"
    }
  ]
}
```

### Stream Events
```
GET /api/stream/{jobId}

Response: Server-Sent Events (SSE)
data: {"message": "Extracting PDF...", "type": "info"}
data: {"message": "Analyzing with AI...", "type": "info"}
data: {"message": "Calculating costs...", "type": "info"}
data: {"message": "Complete", "type": "success"}
```

---

## Deployment Considerations

- **Environment Variables**: GEMINI_API_KEY, GOOGLE_SHEETS_ID, GOOGLE_CREDENTIALS_PATH, PORT, PROFIT_MARGIN_PCT
- **CORS**: Configured for cross-origin requests
- **File Storage**: Upload folder requires write permissions
- **Credentials**: Google OAuth credentials must be available
- **Concurrency**: Thread-safe job store with mutex locking
