import { NodeSDK } from '@opentelemetry/sdk-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-http';
import { OTLPMetricExporter } from '@opentelemetry/exporter-metrics-otlp-http';
import { Resource } from '@opentelemetry/resources';
import { SemanticResourceAttributes } from '@opentelemetry/semantic-conventions';
import { HttpInstrumentation } from '@opentelemetry/instrumentation-http';
import { ExpressInstrumentation } from '@opentelemetry/instrumentation-express';
import { PeriodicExportingMetricReader } from '@opentelemetry/sdk-metrics';
import { env } from './config/env.js';
import { logger } from './logger.js';

let sdk: NodeSDK | null = null;

export async function startTelemetry() {
  if (sdk) return sdk;

  const resource = new Resource({
    [SemanticResourceAttributes.SERVICE_NAME]: env.serviceName,
    [SemanticResourceAttributes.DEPLOYMENT_ENVIRONMENT]: env.environment
  });

  sdk = new NodeSDK({
    resource,
    traceExporter: new OTLPTraceExporter({
      url: `${env.otelExporterEndpoint}/v1/traces`
    }),
    metricReader: new PeriodicExportingMetricReader({
      exporter: new OTLPMetricExporter({
        url: `${env.otelExporterEndpoint}/v1/metrics`
      })
    }),
    instrumentations: [new HttpInstrumentation(), new ExpressInstrumentation()]
  });

  await sdk.start();
  logger.info('OpenTelemetry initialized');
  return sdk;
}

export async function shutdownTelemetry() {
  if (!sdk) return;
  await sdk.shutdown();
  sdk = null;
}
