#  Offline-First Chat Architecture (Queue)

## 1. **Why This Approach**

I chose this approach because it **does not heavily rely on backend changes**, which is critical given the constraint of having only **one backend developer for 2 weeks**.

This allows the Flutter team to own most of the implementation while keeping backend work minimal and achievable within the deadline.

---

## 2. **Architecture Overview**

### Local Database Design

I will use **Hive** as the local database and store each message with the following identifiers:

- `localId` → Unique ID generated on device (UUID)
- `serverId` → ID returned from backend (nullable initially)
- `timestamp` → Message creation time (used for ordering)

This ensures:
- No duplication
- Correct ordering
- Reliable synchronization

---

## 3. **Message Flow**

###  Sending Messages

1. User sends a message
2. Message is **immediately saved in local DB** with:
   - `status = pending`
   - `localId` generated
   - `serverId = null`
3. App checks for **internet connectivity**

**If ONLINE:**
4. Send message to server
5. On success:
   - Update message with `serverId`
   - Update status → `sent`

**If OFFLINE:**
4. Keep message in local DB as `pending`
5. Add it to **sync queue** for retry later

---

###  Receiving Messages

1. Message is received from WebSocket (Pusher) or REST API
2. Before saving locally, validate using:
   - `localId`
   - `serverId`
   - `timestamp`

3. Apply rules:
   - If message already exists → **ignore**
   - Otherwise → **save to local DB**

---

## 4. **Sync Strategy**

### Trigger Points
- App launch
- Internet reconnect
- Periodic background sync

### Sync Steps

1. Retrieve messages with:
   - `status = pending` OR `failed`

2. For each message:
   - Send to server
   - Match using `localId` and `timestamp`

3. On success:
   - Update `serverId`
   - Update status → `sent`

4. Fetch latest messages from server using:
   - `lastSyncedTimestamp`

---

## 5. **Deduplication Strategy**

To ensure **no duplicates and no gaps**, every message is validated using:

- `localId`
- `serverId`
- `timestamp`

### Rules

- Same `serverId` → ignore
- Same `localId` → update existing message
- Otherwise → insert as new

---

## 6. **Data Model**

```dart
class LocalMessage {
  final String localId;
  final String? serverId;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageStatus status;

  const LocalMessage({
    required this.localId,
    this.serverId,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.status,
  });
}
```

---

## 7. **What We Do NOT Build**

- Offline message editing/deletion → requires complex conflict resolution
- End-to-end encryption → out of scope for timeline
- Perfect multi-device sync → backend-heavy

---

## 8. **Risk Analysis**

| Risk | Mitigation |
|------|-----------|
| Duplicate messages | Use `localId + serverId` validation |
| Message ordering issues | Sort using `timestamp` |
| Large local database | Limit stored messages per conversation |
| Sync flooding backend | Batch API requests |

---

## 9. **Success Metrics**

-  Messages can be sent and viewed **offline**
-  No duplicate messages appear
-  No message loss after reconnect
-  Sync completes within acceptable time
-  Reduced user complaints in low-connectivity regions
-  Stable performance with large message history

---
