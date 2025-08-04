from fastapi import FastAPI
from opentelemetry import trace
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from pydantic import BaseModel
from litellm import completion
import os
from dotenv import load_dotenv

load_dotenv()

# Set up OpenTelemetry
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

otlp_exporter = OTLPSpanExporter(endpoint="http://localhost:4318/v1/traces")
span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

app = FastAPI(title="Synapse Gateway")

# Instrument FastAPI
FastAPIInstrumentor.instrument_app(app)

class ChatRequest(BaseModel):
    model: str
    messages: list

@app.get("/healthz")
def health():
    return {"ok": True, "service": "gateway"}

@app.post("/api/v1/chat")
async def chat(request: ChatRequest):
    response = completion(
        model=request.model,
        messages=request.messages
    )
    return response

# Day 4: /api/v1/init, auth, Neon calls
