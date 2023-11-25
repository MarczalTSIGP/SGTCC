SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: activity_identifiers; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.activity_identifiers AS ENUM (
    'proposal',
    'project',
    'monograph'
);


--
-- Name: base_activity_identifiers; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.base_activity_identifiers AS ENUM (
    'proposal',
    'project',
    'monograph'
);


--
-- Name: base_activity_type_identifiers; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.base_activity_type_identifiers AS ENUM (
    'send_document',
    'info'
);


--
-- Name: document_type_identifiers; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.document_type_identifiers AS ENUM (
    'tco',
    'tcai',
    'tdo',
    'tep',
    'tso',
    'adpp',
    'adpj',
    'admg'
);


--
-- Name: examination_board_identifiers; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.examination_board_identifiers AS ENUM (
    'proposal',
    'project',
    'monograph'
);


--
-- Name: examination_board_situations; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.examination_board_situations AS ENUM (
    'approved',
    'reproved',
    'not_appear',
    'under_evaluation'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: academic_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_activities (
    id bigint NOT NULL,
    academic_id bigint,
    activity_id bigint,
    pdf character varying,
    complementary_files character varying,
    title character varying,
    summary text,
    judgment boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_instructions text
);


--
-- Name: academic_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.academic_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: academic_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.academic_activities_id_seq OWNED BY public.academic_activities.id;


--
-- Name: academics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academics (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    ra character varying,
    gender character varying(1),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    profile_image character varying
);


--
-- Name: academics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.academics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: academics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.academics_id_seq OWNED BY public.academics.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id bigint NOT NULL,
    name character varying,
    base_activity_type_id bigint,
    tcc integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    calendar_id bigint,
    initial_date timestamp without time zone,
    final_date timestamp without time zone,
    judgment boolean DEFAULT false,
    identifier public.activity_identifiers,
    final_version boolean DEFAULT false
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignments (
    id bigint NOT NULL,
    professor_id bigint,
    role_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assignments_id_seq OWNED BY public.assignments.id;


--
-- Name: attached_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attached_documents (
    id bigint NOT NULL,
    name character varying,
    file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attached_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attached_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attached_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attached_documents_id_seq OWNED BY public.attached_documents.id;


--
-- Name: base_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.base_activities (
    id bigint NOT NULL,
    name character varying,
    base_activity_type_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tcc integer,
    identifier public.base_activity_identifiers,
    judgment boolean DEFAULT false,
    final_version boolean DEFAULT false,
    days_to_start integer DEFAULT 0,
    duration_in_days integer DEFAULT 0
);


--
-- Name: base_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.base_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: base_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.base_activities_id_seq OWNED BY public.base_activities.id;


--
-- Name: base_activity_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.base_activity_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    identifier public.base_activity_type_identifiers
);


--
-- Name: base_activity_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.base_activity_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: base_activity_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.base_activity_types_id_seq OWNED BY public.base_activity_types.id;


--
-- Name: calendars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calendars (
    id bigint NOT NULL,
    year character varying,
    semester integer,
    tcc integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calendars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calendars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.calendars_id_seq OWNED BY public.calendars.id;


--
-- Name: document_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.document_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    identifier public.document_type_identifiers
);


--
-- Name: document_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.document_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.document_types_id_seq OWNED BY public.document_types.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id bigint NOT NULL,
    content json,
    document_type_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    code character varying,
    request json
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: examination_board_attendees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.examination_board_attendees (
    id bigint NOT NULL,
    examination_board_id bigint,
    professor_id bigint,
    external_member_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: examination_board_attendees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.examination_board_attendees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: examination_board_attendees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.examination_board_attendees_id_seq OWNED BY public.examination_board_attendees.id;


--
-- Name: examination_board_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.examination_board_notes (
    id bigint NOT NULL,
    examination_board_id bigint,
    professor_id bigint,
    external_member_id bigint,
    note integer,
    appointment_file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    appointment_text text
);


--
-- Name: examination_board_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.examination_board_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: examination_board_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.examination_board_notes_id_seq OWNED BY public.examination_board_notes.id;


--
-- Name: examination_boards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.examination_boards (
    id bigint NOT NULL,
    date timestamp without time zone,
    place character varying,
    orientation_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tcc integer,
    identifier public.examination_board_identifiers,
    document_available_until timestamp without time zone,
    final_note integer,
    situation public.examination_board_situations DEFAULT 'under_evaluation'::public.examination_board_situations
);


--
-- Name: examination_boards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.examination_boards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: examination_boards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.examination_boards_id_seq OWNED BY public.examination_boards.id;


--
-- Name: external_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.external_members (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    is_active boolean DEFAULT false,
    gender character varying(1),
    working_area text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_image character varying,
    scholarity_id bigint,
    personal_page character varying,
    encrypted_password character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone
);


--
-- Name: external_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.external_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: external_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.external_members_id_seq OWNED BY public.external_members.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.images (
    id bigint NOT NULL,
    name character varying,
    url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: institutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.institutions (
    id bigint NOT NULL,
    name character varying,
    trade_name character varying,
    cnpj character varying,
    external_member_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    working_area text
);


--
-- Name: institutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.institutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: institutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.institutions_id_seq OWNED BY public.institutions.id;


--
-- Name: meetings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meetings (
    id bigint NOT NULL,
    content text,
    date timestamp without time zone,
    viewed boolean DEFAULT false,
    orientation_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: meetings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meetings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meetings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meetings_id_seq OWNED BY public.meetings.id;


--
-- Name: orientation_calendars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orientation_calendars (
    id bigint NOT NULL,
    calendar_id bigint,
    orientation_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: orientation_calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orientation_calendars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orientation_calendars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orientation_calendars_id_seq OWNED BY public.orientation_calendars.id;


--
-- Name: orientation_supervisors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orientation_supervisors (
    id bigint NOT NULL,
    orientation_id bigint,
    professor_supervisor_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    external_member_supervisor_id bigint
);


--
-- Name: orientation_supervisors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orientation_supervisors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orientation_supervisors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orientation_supervisors_id_seq OWNED BY public.orientation_supervisors.id;


--
-- Name: orientations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orientations (
    id bigint NOT NULL,
    title character varying,
    academic_id bigint,
    advisor_id bigint,
    institution_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying DEFAULT 'IN_PROGRESS'::character varying,
    renewal_justification text,
    cancellation_justification text
);


--
-- Name: orientations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orientations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orientations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orientations_id_seq OWNED BY public.orientations.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id bigint NOT NULL,
    menu_title character varying,
    content text,
    url character varying,
    fa_icon character varying,
    "order" integer,
    publish boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: professor_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.professor_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: professor_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.professor_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: professor_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.professor_types_id_seq OWNED BY public.professor_types.id;


--
-- Name: professors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.professors (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_image character varying,
    username character varying,
    name character varying,
    lattes character varying,
    gender character varying(1),
    is_active boolean DEFAULT false,
    available_advisor boolean,
    scholarity_id bigint,
    professor_type_id bigint,
    working_area text
);


--
-- Name: professors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.professors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: professors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.professors_id_seq OWNED BY public.professors.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    identifier text
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: scholarities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scholarities (
    id bigint NOT NULL,
    name character varying,
    abbr character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: scholarities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scholarities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scholarities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scholarities_id_seq OWNED BY public.scholarities.id;


--
-- Name: signatures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.signatures (
    id bigint NOT NULL,
    orientation_id bigint,
    document_id bigint,
    user_id integer,
    user_type character varying(3),
    status boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: signatures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.signatures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.signatures_id_seq OWNED BY public.signatures.id;


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sites (
    id bigint NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sites_id_seq OWNED BY public.sites.id;


--
-- Name: academic_activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_activities ALTER COLUMN id SET DEFAULT nextval('public.academic_activities_id_seq'::regclass);


--
-- Name: academics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academics ALTER COLUMN id SET DEFAULT nextval('public.academics_id_seq'::regclass);


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments ALTER COLUMN id SET DEFAULT nextval('public.assignments_id_seq'::regclass);


--
-- Name: attached_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attached_documents ALTER COLUMN id SET DEFAULT nextval('public.attached_documents_id_seq'::regclass);


--
-- Name: base_activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.base_activities ALTER COLUMN id SET DEFAULT nextval('public.base_activities_id_seq'::regclass);


--
-- Name: base_activity_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.base_activity_types ALTER COLUMN id SET DEFAULT nextval('public.base_activity_types_id_seq'::regclass);


--
-- Name: calendars id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendars ALTER COLUMN id SET DEFAULT nextval('public.calendars_id_seq'::regclass);


--
-- Name: document_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_types ALTER COLUMN id SET DEFAULT nextval('public.document_types_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: examination_board_attendees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_attendees ALTER COLUMN id SET DEFAULT nextval('public.examination_board_attendees_id_seq'::regclass);


--
-- Name: examination_board_notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_notes ALTER COLUMN id SET DEFAULT nextval('public.examination_board_notes_id_seq'::regclass);


--
-- Name: examination_boards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_boards ALTER COLUMN id SET DEFAULT nextval('public.examination_boards_id_seq'::regclass);


--
-- Name: external_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_members ALTER COLUMN id SET DEFAULT nextval('public.external_members_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: institutions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.institutions ALTER COLUMN id SET DEFAULT nextval('public.institutions_id_seq'::regclass);


--
-- Name: meetings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meetings ALTER COLUMN id SET DEFAULT nextval('public.meetings_id_seq'::regclass);


--
-- Name: orientation_calendars id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientation_calendars ALTER COLUMN id SET DEFAULT nextval('public.orientation_calendars_id_seq'::regclass);


--
-- Name: orientation_supervisors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientation_supervisors ALTER COLUMN id SET DEFAULT nextval('public.orientation_supervisors_id_seq'::regclass);


--
-- Name: orientations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientations ALTER COLUMN id SET DEFAULT nextval('public.orientations_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: professor_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professor_types ALTER COLUMN id SET DEFAULT nextval('public.professor_types_id_seq'::regclass);


--
-- Name: professors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professors ALTER COLUMN id SET DEFAULT nextval('public.professors_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: scholarities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scholarities ALTER COLUMN id SET DEFAULT nextval('public.scholarities_id_seq'::regclass);


--
-- Name: signatures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signatures ALTER COLUMN id SET DEFAULT nextval('public.signatures_id_seq'::regclass);


--
-- Name: sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites ALTER COLUMN id SET DEFAULT nextval('public.sites_id_seq'::regclass);


--
-- Name: academic_activities academic_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_activities
    ADD CONSTRAINT academic_activities_pkey PRIMARY KEY (id);


--
-- Name: academics academics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academics
    ADD CONSTRAINT academics_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: assignments assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: attached_documents attached_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attached_documents
    ADD CONSTRAINT attached_documents_pkey PRIMARY KEY (id);


--
-- Name: base_activities base_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.base_activities
    ADD CONSTRAINT base_activities_pkey PRIMARY KEY (id);


--
-- Name: base_activity_types base_activity_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.base_activity_types
    ADD CONSTRAINT base_activity_types_pkey PRIMARY KEY (id);


--
-- Name: calendars calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendars
    ADD CONSTRAINT calendars_pkey PRIMARY KEY (id);


--
-- Name: document_types document_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_types
    ADD CONSTRAINT document_types_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: examination_board_attendees examination_board_attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_attendees
    ADD CONSTRAINT examination_board_attendees_pkey PRIMARY KEY (id);


--
-- Name: examination_board_notes examination_board_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_notes
    ADD CONSTRAINT examination_board_notes_pkey PRIMARY KEY (id);


--
-- Name: examination_boards examination_boards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_boards
    ADD CONSTRAINT examination_boards_pkey PRIMARY KEY (id);


--
-- Name: external_members external_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_members
    ADD CONSTRAINT external_members_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: institutions institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT institutions_pkey PRIMARY KEY (id);


--
-- Name: meetings meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_pkey PRIMARY KEY (id);


--
-- Name: orientation_calendars orientation_calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientation_calendars
    ADD CONSTRAINT orientation_calendars_pkey PRIMARY KEY (id);


--
-- Name: orientation_supervisors orientation_supervisors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientation_supervisors
    ADD CONSTRAINT orientation_supervisors_pkey PRIMARY KEY (id);


--
-- Name: orientations orientations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientations
    ADD CONSTRAINT orientations_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: professor_types professor_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professor_types
    ADD CONSTRAINT professor_types_pkey PRIMARY KEY (id);


--
-- Name: professors professors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professors
    ADD CONSTRAINT professors_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scholarities scholarities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scholarities
    ADD CONSTRAINT scholarities_pkey PRIMARY KEY (id);


--
-- Name: signatures signatures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signatures
    ADD CONSTRAINT signatures_pkey PRIMARY KEY (id);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: index_academic_activities_on_academic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_academic_activities_on_academic_id ON public.academic_activities USING btree (academic_id);


--
-- Name: index_academic_activities_on_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_academic_activities_on_activity_id ON public.academic_activities USING btree (activity_id);


--
-- Name: index_academics_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_academics_on_reset_password_token ON public.academics USING btree (reset_password_token);


--
-- Name: index_activities_on_base_activity_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_base_activity_type_id ON public.activities USING btree (base_activity_type_id);


--
-- Name: index_activities_on_calendar_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_calendar_id ON public.activities USING btree (calendar_id);


--
-- Name: index_assignments_on_professor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_professor_id ON public.assignments USING btree (professor_id);


--
-- Name: index_assignments_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_role_id ON public.assignments USING btree (role_id);


--
-- Name: index_base_activities_on_base_activity_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_base_activities_on_base_activity_type_id ON public.base_activities USING btree (base_activity_type_id);


--
-- Name: index_documents_on_document_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_document_type_id ON public.documents USING btree (document_type_id);


--
-- Name: index_examination_board_attendees_on_examination_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_board_attendees_on_examination_board_id ON public.examination_board_attendees USING btree (examination_board_id);


--
-- Name: index_examination_board_attendees_on_external_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_board_attendees_on_external_member_id ON public.examination_board_attendees USING btree (external_member_id);


--
-- Name: index_examination_board_attendees_on_professor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_board_attendees_on_professor_id ON public.examination_board_attendees USING btree (professor_id);


--
-- Name: index_examination_board_notes_on_examination_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_board_notes_on_examination_board_id ON public.examination_board_notes USING btree (examination_board_id);


--
-- Name: index_examination_board_notes_on_external_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_board_notes_on_external_member_id ON public.examination_board_notes USING btree (external_member_id);


--
-- Name: index_examination_board_notes_on_professor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_board_notes_on_professor_id ON public.examination_board_notes USING btree (professor_id);


--
-- Name: index_examination_boards_on_orientation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_examination_boards_on_orientation_id ON public.examination_boards USING btree (orientation_id);


--
-- Name: index_external_members_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_external_members_on_reset_password_token ON public.external_members USING btree (reset_password_token);


--
-- Name: index_external_members_on_scholarity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_external_members_on_scholarity_id ON public.external_members USING btree (scholarity_id);


--
-- Name: index_institutions_on_external_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_institutions_on_external_member_id ON public.institutions USING btree (external_member_id);


--
-- Name: index_meetings_on_orientation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_meetings_on_orientation_id ON public.meetings USING btree (orientation_id);


--
-- Name: index_orientation_calendars_on_calendar_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orientation_calendars_on_calendar_id ON public.orientation_calendars USING btree (calendar_id);


--
-- Name: index_orientation_calendars_on_orientation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orientation_calendars_on_orientation_id ON public.orientation_calendars USING btree (orientation_id);


--
-- Name: index_orientation_supervisors_on_external_member_supervisor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orientation_supervisors_on_external_member_supervisor_id ON public.orientation_supervisors USING btree (external_member_supervisor_id);


--
-- Name: index_orientation_supervisors_on_orientation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orientation_supervisors_on_orientation_id ON public.orientation_supervisors USING btree (orientation_id);


--
-- Name: index_orientation_supervisors_on_professor_supervisor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orientation_supervisors_on_professor_supervisor_id ON public.orientation_supervisors USING btree (professor_supervisor_id);


--
-- Name: index_orientations_on_academic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orientations_on_academic_id ON public.orientations USING btree (academic_id);


--
-- Name: index_orientations_on_advisor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orientations_on_advisor_id ON public.orientations USING btree (advisor_id);


--
-- Name: index_orientations_on_institution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orientations_on_institution_id ON public.orientations USING btree (institution_id);


--
-- Name: index_professors_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_professors_on_email ON public.professors USING btree (email);


--
-- Name: index_professors_on_professor_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_professors_on_professor_type_id ON public.professors USING btree (professor_type_id);


--
-- Name: index_professors_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_professors_on_reset_password_token ON public.professors USING btree (reset_password_token);


--
-- Name: index_professors_on_scholarity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_professors_on_scholarity_id ON public.professors USING btree (scholarity_id);


--
-- Name: index_professors_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_professors_on_username ON public.professors USING btree (username);


--
-- Name: index_signatures_on_document_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_signatures_on_document_id ON public.signatures USING btree (document_id);


--
-- Name: index_signatures_on_orientation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_signatures_on_orientation_id ON public.signatures USING btree (orientation_id);


--
-- Name: assignments fk_rails_0028583927; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT fk_rails_0028583927 FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: academic_activities fk_rails_020b78b770; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_activities
    ADD CONSTRAINT fk_rails_020b78b770 FOREIGN KEY (academic_id) REFERENCES public.academics(id);


--
-- Name: orientations fk_rails_128660e846; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientations
    ADD CONSTRAINT fk_rails_128660e846 FOREIGN KEY (academic_id) REFERENCES public.academics(id);


--
-- Name: orientations fk_rails_1293b49410; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientations
    ADD CONSTRAINT fk_rails_1293b49410 FOREIGN KEY (advisor_id) REFERENCES public.professors(id);


--
-- Name: examination_board_attendees fk_rails_19395b102e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_attendees
    ADD CONSTRAINT fk_rails_19395b102e FOREIGN KEY (professor_id) REFERENCES public.professors(id);


--
-- Name: base_activities fk_rails_24e9fd5314; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.base_activities
    ADD CONSTRAINT fk_rails_24e9fd5314 FOREIGN KEY (base_activity_type_id) REFERENCES public.base_activity_types(id);


--
-- Name: signatures fk_rails_2ecb9ebbce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signatures
    ADD CONSTRAINT fk_rails_2ecb9ebbce FOREIGN KEY (document_id) REFERENCES public.documents(id);


--
-- Name: orientations fk_rails_3f706af548; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientations
    ADD CONSTRAINT fk_rails_3f706af548 FOREIGN KEY (institution_id) REFERENCES public.institutions(id);


--
-- Name: orientation_supervisors fk_rails_469a0960ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientation_supervisors
    ADD CONSTRAINT fk_rails_469a0960ef FOREIGN KEY (professor_supervisor_id) REFERENCES public.professors(id);


--
-- Name: examination_board_attendees fk_rails_4ff67d3b09; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_attendees
    ADD CONSTRAINT fk_rails_4ff67d3b09 FOREIGN KEY (examination_board_id) REFERENCES public.examination_boards(id);


--
-- Name: examination_boards fk_rails_6ce8a3c36f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_boards
    ADD CONSTRAINT fk_rails_6ce8a3c36f FOREIGN KEY (orientation_id) REFERENCES public.orientations(id);


--
-- Name: examination_board_notes fk_rails_7296e08998; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_notes
    ADD CONSTRAINT fk_rails_7296e08998 FOREIGN KEY (professor_id) REFERENCES public.professors(id);


--
-- Name: examination_board_notes fk_rails_7660d85150; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_notes
    ADD CONSTRAINT fk_rails_7660d85150 FOREIGN KEY (external_member_id) REFERENCES public.external_members(id);


--
-- Name: signatures fk_rails_8640219f96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signatures
    ADD CONSTRAINT fk_rails_8640219f96 FOREIGN KEY (orientation_id) REFERENCES public.orientations(id);


--
-- Name: external_members fk_rails_99b473ccbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_members
    ADD CONSTRAINT fk_rails_99b473ccbd FOREIGN KEY (scholarity_id) REFERENCES public.scholarities(id);


--
-- Name: professors fk_rails_a4147a539c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professors
    ADD CONSTRAINT fk_rails_a4147a539c FOREIGN KEY (scholarity_id) REFERENCES public.scholarities(id);


--
-- Name: examination_board_notes fk_rails_a86dc78bcc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_notes
    ADD CONSTRAINT fk_rails_a86dc78bcc FOREIGN KEY (examination_board_id) REFERENCES public.examination_boards(id);


--
-- Name: institutions fk_rails_acbdcff141; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT fk_rails_acbdcff141 FOREIGN KEY (external_member_id) REFERENCES public.external_members(id);


--
-- Name: academic_activities fk_rails_becf2c2c51; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_activities
    ADD CONSTRAINT fk_rails_becf2c2c51 FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- Name: professors fk_rails_d312b49f1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professors
    ADD CONSTRAINT fk_rails_d312b49f1b FOREIGN KEY (professor_type_id) REFERENCES public.professor_types(id);


--
-- Name: activities fk_rails_e2c9dff8e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT fk_rails_e2c9dff8e3 FOREIGN KEY (base_activity_type_id) REFERENCES public.base_activity_types(id);


--
-- Name: activities fk_rails_e5fc15bcd1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT fk_rails_e5fc15bcd1 FOREIGN KEY (calendar_id) REFERENCES public.calendars(id);


--
-- Name: orientation_supervisors fk_rails_e6e96ff3a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientation_supervisors
    ADD CONSTRAINT fk_rails_e6e96ff3a7 FOREIGN KEY (orientation_id) REFERENCES public.orientations(id);


--
-- Name: documents fk_rails_e77e122717; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT fk_rails_e77e122717 FOREIGN KEY (document_type_id) REFERENCES public.document_types(id);


--
-- Name: examination_board_attendees fk_rails_ea3977d619; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_board_attendees
    ADD CONSTRAINT fk_rails_ea3977d619 FOREIGN KEY (external_member_id) REFERENCES public.external_members(id);


--
-- Name: orientation_supervisors fk_rails_fb632a739a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orientation_supervisors
    ADD CONSTRAINT fk_rails_fb632a739a FOREIGN KEY (external_member_supervisor_id) REFERENCES public.external_members(id);


--
-- Name: assignments fk_rails_fbad423076; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT fk_rails_fbad423076 FOREIGN KEY (professor_id) REFERENCES public.professors(id);


--
-- Name: meetings fk_rails_fbe45d3e16; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT fk_rails_fbe45d3e16 FOREIGN KEY (orientation_id) REFERENCES public.orientations(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180925232654'),
('20190108180129'),
('20190110190129'),
('20190221210736'),
('20190221235605'),
('20190227110044'),
('20190227113434'),
('20190228200940'),
('20190301182443'),
('20190301182724'),
('20190301200133'),
('20190305172016'),
('20190307191331'),
('20190307191510'),
('20190313004419'),
('20190313012819'),
('20190313024238'),
('20190313025705'),
('20190313175459'),
('20190313235643'),
('20190320162008'),
('20190320162252'),
('20190320174948'),
('20190326105338'),
('20190326110109'),
('20190331143156'),
('20190407231337'),
('20190407231606'),
('20190407232636'),
('20190408000610'),
('20190411194740'),
('20190411203006'),
('20190416182519'),
('20190416182626'),
('20190416205026'),
('20190423031128'),
('20190429185922'),
('20190430114105'),
('20190528170108'),
('20190530142431'),
('20190530143325'),
('20190601190503'),
('20190601223851'),
('20190613174601'),
('20190613175702'),
('20190613182041'),
('20190704195335'),
('20190710223922'),
('20190715175442'),
('20190715202601'),
('20190715211414'),
('20190718160910'),
('20190719182125'),
('20190725025158'),
('20190731173754'),
('20190731215128'),
('20190802155315'),
('20190802163145'),
('20190802181514'),
('20190808174240'),
('20190816174008'),
('20190902121046'),
('20190906195155'),
('20190930194124'),
('20191001130912'),
('20191002115343'),
('20191002121129'),
('20191002131434'),
('20191002141045'),
('20191002141405'),
('20191002142408'),
('20191002144740'),
('20191003203113'),
('20191004173028'),
('20191004191641'),
('20191010143250'),
('20191011133414'),
('20191011133608'),
('20191125224723'),
('20200710170737'),
('20231004230530'),
('20231017133608');


