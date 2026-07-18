---
title: "Hexagonal Architecture"
description: "What is Hexagonal Architecture"
pubDate: "July 11 2026"
heroImage: ""
tags: ["architecture", "java", "design"]
---

# What is Hexagonal Architecture

Hexagonal Architecture, also known as the Ports and Adapters pattern, was introduced by Alistair Cockburn.

The goal of this architecture is to decouple the application's core business logic from external dependencies like databases or 3rd party APIs,.. By isolating the core, this pattern make enterprise applications and microservices more maintainable, highly testable and adaptable to technological changes over time.

# Core components

## 1. The Domain (Core)

This sits at the center of the hexagon, contains pure business rules, entities and domain logics. The core should have absolutely no external dependencies - not even on frameworks like Spring.

## 2. Ports

Interfaces that live on the boundary of the application and define the contracts between the domain logic and the outside world.

### 2.1 Inbound ports (Primary/Driving)

These define the use cases of the system. They dictate what the user or an external system wants the application todo (e.g: an interface like ValidateRequest).

### 2.2 Outbound ports (Secondary/Driven)

THese dedine how the application interacts with the outside world to fetch data or publish event (e.g: PaymentStatusRepository)

## 3. Adapter

These are the concrete, technology-specific implementations that interact with the ports.

### 3.1 Driving adapters (Primary)

These translate external requests into calls to the inbound ports. In a Spring Boot app, this is typically a @RestController handling HTTP request.

### 3.2 Driven adapters (Secondary)

THese implement the outbound ports to handle infrastructure-specific tasks. Examples include Spring Data JPA repositories or Kafka publishers.

# Mapping the Tech Stack

- **REST API:** Driving Adapter (Spring `@RestController`).
- **Postgres (Persistence):** Driven Adapter implementing `DatabasePort` using Spring Data JPA.
- **Redis (Caching):** Driven Adapter implementing `CachePort` using Spring Data Redis.
- **Kafka / MQ:**
  - **Consumers:** Driving Adapters triggering core logic.
  - **Publishers:** Driven Adapters using `KafkaTemplate`.
  - **Kafka Streams:** Can act as both inbound and outbound adapters.

# Example Project Structure

```text
com.example.app
├── domain                  (Pure Java business logic)
├── application.port.in     (Interfaces for use cases)
├── application.port.out    (Interfaces for DBs/Messaging)
├── adapter.in.web          (Spring REST Controllers)
├── adapter.in.messaging    (Kafka / MQ Consumers)
├── adapter.out.persistence (Spring Data Postgres)
├── adapter.out.cache       (Spring Data Redis)
├── adapter.out.messaging   (Kafka / MQ Producers)
└── config                  (Spring @Configuration wiring)
```

# Trade-offs

## Pros:

- Technology Independence: You can swap out external systems (e.g., migrating from MongoDB to PostgreSQL) simply by writing a new driven adapter; the core domain remains untouched.

- Focus on Business Value: You can start writing and testing business logic iteratively before making final decisions about your database or web framework.

- Future-Proofing: It aligns naturally with Domain-Driven Design (DDD) and helps keep microservices clean as they scale.

## Cons:

- Increased Complexity: It introduces more layers of abstraction, additional boilerplate code, and a higher cognitive load, especially for developers who are new to the pattern.

- Mapping Overhead: You often need to map objects between layers (e.g., translating a Domain User entity into a Spring Data UserDocument adapter class) to prevent database details from leaking into the core.

# Architecture comparison

---

# Architectural Showdown

| Architecture  | Core Philosophy                                        | Best For                            | Complexity  |
| ------------- | ------------------------------------------------------ | ----------------------------------- | ----------- |
| **Layered**   | Top-down dependency (Controller → Service → DB).       | Simple CRUD apps, MVPs.             | Low         |
| **Clean**     | Strict concentric layers; dependencies point inward.   | Complex enterprise systems.         | High        |
| **Onion**     | Domain model at center, outward with app services.     | DDD-focused projects.               | Medium-High |
| **Hexagonal** | Core surrounded by "Ports", implemented by "Adapters". | Systems with multiple integrations. | Medium-High |
