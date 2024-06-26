create table mr_payment_methods(
    id                      bigserial primary key,
    user_id                 bigint not null,
    key                     varchar(64),
    name                    varchar(128),
    description             text,
    status                  varchar(64),
    last_modification_date  timestamp,
    creation_date           timestamp
);
create table mr_requests(
    id                      bigserial primary key,
    source_id               bigint not null,
    target_id               bigint not null,
    source_name             varchar(128),
    target_name             varchar(128),
    payment_method_id       bigint not null,
    notes                   text,
    request_date            timestamp,
    limit_date              timestamp,
    amount                  numeric default 0,
    status                  varchar(64),
    completed               boolean default '0',
    deleted                 boolean default '0',
    last_modification_date  timestamp,
    creation_date           timestamp
);
create table mr_request_attachments(
    id                      bigserial primary key,
    request_id              bigint not null,
    name                    varchar(64),
    description             text,
    filename                varchar(256),
    atype                    varchar(64),
    last_modification_date  timestamp,
    creation_date           timestamp
);
create table mr_request_states(
    id                      bigserial primary key,
    request_id              bigint not null,
    user_id                 bigint not null,
    old_status              varchar(64),
    new_status              varchar(64),
    notes                   text,
    deleted                 boolean default '0',
    last_modification_date  timestamp,
    creation_date           timestamp
);
create table mr_parameters(
    id                      bigserial primary key,
    key                     varchar(128),
    value                   text,
    last_modification_date  timestamp,
    creation_date           timestamp
);
create table mr_wallets(
    id                      bigserial primary key,
    user_id                 bigint not null,
    amount                  numeric,
    locked_amount           numeric default 0,
    available_amount        numeric default 0,
    last_modification_date  timestamp,
    creation_date           timestamp
);
create table mr_wallet_charges(
    id                      bigserial primary key,
    wallet_id               bigint not null,
    request_id              bigint not null,
    amount                  numeric,
    fee                     numeric default 0,
    charged_amount          numeric,
    last_modification_date  timestamp,
    creation_date           timestamp
);
create table mr_veriff_sessions(
    id                      bigserial primary key,
    user_id                 bigint not null,
    session_id              varchar(128),
    url                     varchar(256),
    status                  varchar(32),
    session_token           varchar(256),
    last_modification_date  timestamp,
    creation_date           timestamp
);
