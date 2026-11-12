---
name: ux-ecommerce
description: Use when designing or reviewing an online shop or its parts (catalog, search, filters, product page, cart, checkout, payment, shipping and returns, prices and taxes, order status, post-purchase emails), or checking a purchase flow for dark patterns.
---

# Online shops

## Overview
Builds on `ux-design`; speed and cookie banner: `ux-landing`; implementation: `frontend-web`. ~70% of carts are abandoned (Baymard), mostly over surprise costs, forced accounts and long checkouts.

## Catalog and search
- Search on every page; tolerant of typos, synonyms, plurals; suggestions while typing.
- No results: spelling fixes, related categories, contact; never a dead end.
- Category-specific filters with counts, active ones as chips; "Load more" over infinite scroll.

## Product page
- Several large images (zoom, scale, in use); specs as a scannable list.
- Price, stock and delivery date beside "Add to cart".
- Unavailable variants shown disabled, not hidden; size guide one click away.
- Reviews with rating distribution; keep negative ones.

## Cart
- Edit quantity, remove with undo, thumbnail and variant shown.
- Full total early (shipping, taxes, discounts); coupon field collapsed.

## Checkout
- Guest checkout as the most prominent option; offer an account afterwards.
- Few steps, progress shown; ~7-8 fields (Baymard); address lookup plus manual entry; "billing same as shipping" checked.
- Right `autocomplete` and keyboards; never block paste.
- Familiar payment methods and wallets; keep all input after errors or a declined card.
- Review step shows total, delivery date, address and payment before "Place order".

## Shipping, returns, prices
- Delivery dates ("Arrives Thu 14"), not speeds ("3-5 days"); free-shipping threshold stated.
- Return policy in plain words (period, cost, how), linked from product, cart and checkout.
- EU: prices include VAT; consistent currency format.

## After purchase
- Confirmation page and email: order number, items, total, delivery date, address.
- Email on every change (shipped with tracking, delayed, delivered); order status page without login; easy cancel, return and contact.

## Dark patterns to avoid
- Hidden costs, preselected add-ons, sneak-into-basket, hidden subscriptions.
- Fake urgency, scarcity or reviews; confirmshaming ("No, I hate savings"); hard-to-cancel subscriptions.

## Common mistakes
| Mistake | Fix |
|---|---|
| Account required | Guest checkout first |
| Shipping revealed last | Total visible in cart |
| "3-5 business days" | Concrete date |
| Hidden unavailable variants | Shown disabled |
| Form cleared after error | Keep input |
| Resetting countdown | Real deadlines only |

Sources: Baymard Institute (cart abandonment, checkout, product page, search), NN/g (e-commerce), deceptive.design, Google Search Central (Product structured data), vercel-labs/web-interface-guidelines, nextlevelbuilder/ui-ux-pro-max-skill, anthropics/skills frontend-design.
