CREATE TABLE "users" (
    "id" BIGSERIAL NOT NULL,
    "username" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "is_admin" BOOLEAN NOT NULL
    PRIMARY KEY ("id"),
    CONSTRAINT "users_username_unique" UNIQUE ("username"),
    CONSTRAINT "users_email_unique" UNIQUE ("email")
);

CREATE TABLE "trades" (
    "id" BIGSERIAL NOT NULL,
    "user_id1" BIGINT NOT NULL,
    "user_id2" BIGINT,
    "status" VARCHAR(255) NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id1") REFERENCES "users" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("user_id2") REFERENCES "users" ("id") ON DELETE CASCADE
);

CREATE TABLE "offers" (
    "trade_id" BIGINT NOT NULL,
    "card_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "quantity" BIGINT NOT NULL DEFAULT 1,
    PRIMARY KEY ("trade_id", "card_id", "user_id"),
    FOREIGN KEY ("trade_id") REFERENCES "trades" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE
);

CREATE TABLE "friends" (
    "user_id1" BIGINT NOT NULL,
    "user_id2" BIGINT NOT NULL,
    "status" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY ("user_id1", "user_id2"),
    FOREIGN KEY ("user_id1") REFERENCES "users" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("user_id2") REFERENCES "users" ("id") ON DELETE CASCADE,
    CONSTRAINT check_user_order CHECK (user_id1 < user_id2)
);

CREATE TABLE "users_cards" (
    "user_id" BIGINT NOT NULL,
    "card_id" BIGINT NOT NULL,
    "quantity" BIGINT NOT NULL DEFAULT 1,
    PRIMARY KEY ("user_id", "card_id"),
    FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE
);

CREATE TABLE "cards_trades" (
    "user_id" BIGINT NOT NULL,
    "trade_id" BIGINT NOT NULL,
    "card_id" BIGINT NOT NULL,
    PRIMARY KEY ("user_id", "trade_id", "card_id"),
    FOREIGN KEY ("trade_id") REFERENCES "trades" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE
);
