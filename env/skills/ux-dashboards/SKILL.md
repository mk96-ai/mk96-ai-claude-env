---
name: ux-dashboards
description: Use when designing or reviewing a dashboard, admin panel, back-office screen, report, KPI view or data table, or deciding metrics layout, table behavior, filters, live updates, chart type, drill-down or export.
---

# Dashboards and data-heavy screens

## Overview
Builds on `ux-design`. A dashboard answers one question at a glance; details are one click away. Chart construction and palettes: `dataviz`. Implementation: `frontend-web`.

## Information hierarchy
- Decide the audience and type first: operational (monitor now, act) or analytical (review, explore later).
- Key metrics fit one screen; most important top-left.
- 5-7 KPIs per view; group related items by proximity, not boxes.
- Every number gets context: target, previous period or trend (delta + sparkline).
- Status by deviation: neutral by default, color only what needs attention, always with icon or text.

## Density
- Data-ink first: no gauges, 3D, heavy gridlines or decorative icons.
- Tabular (monospaced) digits, consistent units and decimals, abbreviate large numbers (12.4k) with the exact value on hover.
- Offer comfortable/compact density for power users; never shrink text below 12 px.

## Tables
| Topic | Rule |
|---|---|
| Alignment | Text left, numbers and dates right, header aligned like its column |
| First column | Human-readable identifier, frozen with the header when scrolling |
| Columns | Ordered by importance, related ones adjacent; hide/reorder without drag-only |
| Sorting | Click header; show direction; sensible default sort stated |
| Rows | Light dividers or zebra, hover highlight; 1-2 inline actions, more in a menu |
| Bulk | Checkboxes + action bar, "select all" across pages explicit |
| Volume | Pagination with total count, or virtualized scroll; never load everything |

## Filters
- Visible, quick, and clearly marked when active (chips + "Clear all"); show the result count.
- Global time range top-right; filters and sort kept in the URL so views can be shared and survive refresh.

## Live data
- Show "Updated 2 min ago"; refresh in place without layout shift or stolen focus.
- Operational: live, briefly highlight changes, pausable. Analytical: periodic is fine.

## Empty and partial data
- Empty: explain why (no data yet vs. filters too narrow) and the next action.
- Partial or stale: load each widget independently, mark missing values ("—", "No data"), never show 0 for unknown.

## Chart basics
- Bar to compare (sorted, axis from zero), line over time, table for exact values; pie only for 2-3 big shares.
- Direct labels over legends; one highlight color, rest grey; small multiples over cramped multi-series charts.

## Drill-down and export
- Every summary is clickable to its detail, with breadcrumbs back and filters carried over.
- Export (CSV/XLSX) respects current filters and columns.

## Pre-ship checklist
- [ ] Main question answered in 5 seconds
- [ ] Every KPI has context
- [ ] Tables: alignment, sticky header, sorting, volume handled
- [ ] Active filters visible, state in URL
- [ ] Empty, partial, stale and error states done

Sources: NN/g (dashboards, data tables), Stephen Few (Information Dashboard Design), Edward Tufte (data-ink, small multiples), Material Design data tables, vercel-labs/web-interface-guidelines, nextlevelbuilder/ui-ux-pro-max-skill, wshobson/agents ui-design, WCAG 2.2.
