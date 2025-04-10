// tracing.js
const { NodeSDK } = require('@opentelemetry/sdk-node');
const { getNodeAutoInstrumentations } = require('@opentelemetry/auto-instrumentations-node');
const { JaegerExporter } = require('@opentelemetry/exporter-jaeger');

const jaegerExporter = new JaegerExporter({
    endpoint: 'http://localhost:14268/api/traces'
});

const sdk = new NodeSDK({
    traceExporter: jaegerExporter,
    instrumentations: [getNodeAutoInstrumentations()],
    serviceName: 'shark-website' // Optional: helpful for Jaeger UI
});

try {
    sdk.start(); // ✅ Now sync
    console.log('✅ OpenTelemetry + Jaeger initialized');
} catch (error) {
    console.error('❌ Failed to initialize OpenTelemetry', error);
}
