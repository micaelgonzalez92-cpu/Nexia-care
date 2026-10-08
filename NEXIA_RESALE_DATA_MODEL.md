# NEXIA RESALE — DATA MODEL

## Core entities
Supplier, Batch, Item/SKU, Inspection, Preparation, Listing, Channel, PriceEvent, Order, Shipment, Return, Expense, Payout, Experiment, EvidenceEvent.

## Item/SKU fields
sku, origin, supplier, batch_id, brand, category, subcategory, size, colour, material, condition_grade, defects, measurements, authenticity_status, vintage_signal, prep_minutes, acquisition_cost, transport_cost, prep_cost, status.

## Listing fields
listing_id, sku, channel, published_at, asking_price, minimum_price, title, description, photo_set, views, favourites, messages, offers.

## Sale fields
order_id, sku, channel, sale_date, realized_price, variable_channel_cost, packaging_cost, return_loss, days_to_sale, realized_contribution, completion_status.

## Own inventory rule
OWN items have acquisition_cost = 0 unless Kael supplies a justified economic historical cost. They remain analytically separate from sourced inventory.

## Sourcing rule
Allocate batch purchase + inbound transport across received/sellable units using the chosen allocation method and record it explicitly. Do not infer profit from supplier €/kg or asking prices.

## Evidence events
Every meaningful event records timestamp, source, value, confidence/evidence type and experiment id. Asking price is never a revenue event.

## Minimum dashboard metrics
Inventory received, sellable %, listed, sold, realized revenue, realized contribution, contribution/item, contribution/minute, days to sale, return rate, cash recovered, remaining inventory at cost.
