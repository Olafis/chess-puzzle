--
-- PostgreSQL database dump
--

\restrict XFNuSbDP84iiNBp1AjPM93PyXQ8Tw1RmS6UV4dgNyF2ImSHtl0w4D8VyR3puP8R

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.9 (Ubuntu 17.9-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, username, email, "emailVerified", image, name, rating, "styleProfile", "createdAt", "updatedAt", "passwordHash") FROM stdin;
cmm6gn0rn000004l10v5swj6n	\N	promptengine.dev@gmail.com	\N	\N	olafis_dev	1800	\N	2026-02-28 15:12:46.499	2026-03-01 03:17:40.618	$2b$12$0ra/g4NA5WqYTV16JLeCveAjyJD7ZPY1XHr5Cn3apo3/AcPYaWAAK
\.


--
-- Data for Name: Account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Account" (id, "userId", type, provider, "providerAccountId", refresh_token, access_token, expires_at, token_type, scope, id_token, session_state) FROM stdin;
\.


--
-- Data for Name: Game; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Game" (id, pgn, "whitePlayer", "blackPlayer", "whiteElo", "blackElo", event, site, date, result, source, "createdAt") FROM stdin;
d70c5941-6492-4247-b9ba-3e27bfb08013	[Event "Rated Blitz game"]\n[Site "https://lichess.org/vb3w3rmn"]\n[Date "????.??.??"]\n[Round "?"]\n[White "nichiren1967"]\n[Black "chinokoli"]\n[Result "1/2-1/2"]\n[UTCDate "2012.12.31"]\n[UTCTime "23:04:28"]\n[WhiteElo "1878"]\n[BlackElo "1940"]\n[WhiteRatingDiff "+2"]\n[BlackRatingDiff "-2"]\n[ECO "B21"]\n[Opening "Sicilian Defense: McDonnell Attack"]\n[TimeControl "300+0"]\n[Termination "Normal"]\n\n1. e4 c5 2. f4 d5 3. exd5 Qxd5 4. Nc3 Qd8 5. Bc4 Bf5 6. d3 a6 7. g4 Bd7 8. a4 e6 9. Bd2 Bc6 10. Nf3 Bxf3 11. Qxf3 Qh4+ 12. Qg3 Qxg3+ 13. hxg3 Nc6 14. O-O-O O-O-O 15. f5 Ne5 16. fxe6 Nxc4 17. dxc4 fxe6 18. Rde1 Bd6 19. Bf4 Bxf4+ 20. gxf4 Nh6 21. g5 Nf5 22. Rxe6 Rd4 23. Rf1 Rxc4 24. Re5 g6 25. Kd2 Rd8+ 26. Kc1 Rd7 27. Nd5 Rd6 28. Ne7+ Nxe7 29. Rxe7 Rd7 30. Rxd7 Kxd7 31. b3 Re4 32. Kb2 Ke6 33. Kc3 Kf5 34. Rh1 Re7 35. Rf1 Re4 36. Rh1 Rxf4 37. Rxh7 Kxg5 38. Rxb7 Rf6 39. Rc7 Kf4 40. Rxc5 g5 41. b4 g4 42. Rc4+ Kf3 43. Rc5 Rg6 44. Rf5+ Kg2 45. b5 axb5 46. axb5 g3 47. Kb4 Kh1 48. Rd5 g2 49. Rd1+ g1=Q 50. Rxg1+ Kxg1 51. c4 Kf2 52. c5 Ke3 53. b6 Kd4 54. b7 Rg1 55. Kb5 Rb1+ 56. Kc6 Rb4 57. Kc7 Kxc5 58. b8=Q Rxb8 59. Kxb8 1/2-1/2	nichiren1967	chinokoli	1878	1940	Rated Blitz game	https://lichess.org/vb3w3rmn	2012-12-31 00:00:00	1/2-1/2	vb3w3rmn	2026-02-28 11:06:15.817
f06a982a-03b8-4ca7-8abe-9bf7874d8123	[Event "Rated Bullet game"]\n[Site "https://lichess.org/6vapfe1h"]\n[Date "????.??.??"]\n[Round "?"]\n[White "800"]\n[Black "Voltvolf"]\n[Result "1-0"]\n[UTCDate "2012.12.31"]\n[UTCTime "23:17:15"]\n[WhiteElo "1981"]\n[BlackElo "1601"]\n[WhiteRatingDiff "+2"]\n[BlackRatingDiff "-3"]\n[ECO "A15"]\n[Opening "English Opening: Anglo-Indian Defense, King's Knight Variation"]\n[TimeControl "60+1"]\n[Termination "Time forfeit"]\n\n1. c4 Nf6 2. Nf3 e6 3. e3 c5 4. Nc3 Nc6 5. Be2 b6 6. O-O Bb7 7. b3 Be7 8. Bb2 O-O 9. Rc1 e5 10. d4 e4 11. Ng5 cxd4 12. exd4 d5 13. cxd5 Nxd5 14. Ngxe4 Nxc3 15. Bxc3 Nxd4 16. Qxd4 Qxd4 17. Bxd4 Bxe4 18. Rc7 Bd6 19. Rd7 Bf4 20. g3 Bf5 21. Rd5 Be6 22. Rb5 Bh6 23. Bf3 Rad8 24. Be5 Rd2 25. a4 g6 26. Kg2 Bg7 27. Bxg7 Kxg7 28. a5 Rb8 29. axb6 Rxb6 30. Rxb6 axb6 31. Rb1 Rd3 32. b4 b5 33. Be2 Bd5+ 34. Kf1 Rc3 35. Bxb5 Be4 36. Re1 Bd5 37. Be2 Bc4 38. Bxc4 Rxc4 39. Rb1 Rc6 40. b5 Rb6 41. Ke2 Kf6 42. Kd3 Ke6 43. Kc4 Kd6 44. Rd1+ Kc7 45. Re1 Kd6 46. Kb4 h5 47. f4 f5 48. Re5 Kc7 49. Kc5 1-0	800	Voltvolf	1981	1601	Rated Bullet game	https://lichess.org/6vapfe1h	2012-12-31 00:00:00	1-0	6vapfe1h	2026-02-28 11:10:04.376
52bc6550-ea2f-444e-a203-de0e4afb3bf2	[Event "Rated Blitz game"]\n[Site "https://lichess.org/i5u1h3yk"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Abd0"]\n[Black "Killi"]\n[Result "0-1"]\n[UTCDate "2012.12.31"]\n[UTCTime "23:19:01"]\n[WhiteElo "1440"]\n[BlackElo "1502"]\n[WhiteRatingDiff "-10"]\n[BlackRatingDiff "+9"]\n[ECO "C55"]\n[Opening "Italian Game: Two Knights Defense, Modern Bishop's Opening"]\n[TimeControl "420+0"]\n[Termination "Time forfeit"]\n\n1. e4 e5 2. Nf3 Nc6 3. Bc4 Nf6 4. d3 h6 5. O-O Bc5 6. h3 d6 7. Nc3 Nd4 8. Nd5 Nxd5 9. exd5 c6 10. a3 cxd5 11. Bxd5 Be6 12. Bxb7 Rb8 13. Ba6 O-O 14. c3 Nf5 15. d4 exd4 16. cxd4 Bb6 17. Be3 d5 18. Ne5 Nxe3 19. fxe3 Qg5 20. Qf3 f6 21. Ng4 Bc7 22. b4 Bxg4 23. hxg4 Qh4 24. Qxd5+ Kh8 25. Qh5 Qg3 26. Qh3 Rbe8 27. Qxg3 Bxg3 28. Rf3 Bh4 29. g3 Bg5 30. Re1 Re6 31. Bd3 Rfe8 32. e4 Rc8 33. e5 Bd2 34. Re2 Bc3 35. exf6 Bxd4+ 36. Kh2 Rxe2+ 37. Bxe2 Bxf6 38. a4 Rc2 39. Rf2 Bd4 40. Rf8+ Kh7 41. Re8 Bc3 42. Kh3 Bxb4 43. Bd3+ g6 44. Bxc2 a5 45. Kh4 Kg7 46. g5 h5 47. g4 hxg4 48. Kxg4 Kf7 49. Rc8 Bd2 0-1	Abd0	Killi	1440	1502	Rated Blitz game	https://lichess.org/i5u1h3yk	2012-12-31 00:00:00	0-1	i5u1h3yk	2026-02-28 11:10:40.801
c1fcf8ea-0202-4560-8fd3-29ab00fefc3e	[Event "Rated Classical game"]\n[Site "https://lichess.org/ui2g2idg"]\n[Date "????.??.??"]\n[Round "?"]\n[White "6WX"]\n[Black "adamsrj"]\n[Result "0-1"]\n[UTCDate "2012.12.31"]\n[UTCTime "23:31:06"]\n[WhiteElo "1472"]\n[BlackElo "1504"]\n[WhiteRatingDiff "-39"]\n[BlackRatingDiff "+9"]\n[ECO "B30"]\n[Opening "Sicilian Defense: Nyezhmetdinov-Rossolimo Attack"]\n[TimeControl "1560+30"]\n[Termination "Normal"]\n\n1. e4 c5 2. Nf3 Nc6 3. Bb5 d6 4. c3 Bd7 5. d4 cxd4 6. cxd4 Qa5+ 7. Nc3 Rc8 8. d5 Nb8 9. Bxd7+ Nxd7 10. Bd2 Ngf6 11. Qc2 Qa6 12. Nd4 g6 13. Qb3 Bg7 14. Ndb5 O-O 15. O-O Ne8 16. Rac1 Nc7 17. Nxc7 Rxc7 18. Na4 Rxc1 19. Rxc1 b5 20. Nc3 Qb7 21. Nxb5 Rc8 22. Nxa7 Rxc1+ 23. Bxc1 Qxa7 24. Be3 Qa5 25. h3 Be5 26. Kf1 Nc5 27. Qb8+ Kg7 28. a3 Nd3 29. b4 Qa4 30. Ke2 Qc2+ 31. Bd2 Bc3 0-1	6WX	adamsrj	1472	1504	Rated Classical game	https://lichess.org/ui2g2idg	2012-12-31 00:00:00	0-1	ui2g2idg	2026-02-28 11:13:30.762
5c4cc43f-efd9-4de8-93ea-b21cbd32bca4	[Event "Rated Bullet game"]\n[Site "https://lichess.org/5dpjox73"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Gardo"]\n[Black "sonie"]\n[Result "0-1"]\n[UTCDate "2012.12.31"]\n[UTCTime "23:38:47"]\n[WhiteElo "1627"]\n[BlackElo "1806"]\n[WhiteRatingDiff "-6"]\n[BlackRatingDiff "+6"]\n[ECO "A04"]\n[Opening "Zukertort Opening: Queenside Fianchetto Variation"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. Nf3 b6 2. d4 Bb7 3. c4 g6 4. Nc3 Bg7 5. e4 e6 6. d5 Ne7 7. Bd3 exd5 8. exd5 c6 9. Be4 cxd5 10. Bxd5 Bxd5 11. cxd5 d6 12. O-O Nd7 13. Re1 O-O 14. a3 Be5 15. Rb1 Bxc3 16. bxc3 Rc8 17. c4 Nc5 18. Bd2 Nf5 19. Bf4 Qd7 20. Qc2 Rfe8 21. Ng5 Rxe1+ 22. Rxe1 Re8 23. Rxe8+ Qxe8 24. g3 h6 25. Nh3 Kg7 26. Bxd6 Ne4 27. Qb2+ Kg8 28. Be5 f6 29. Bxf6 Kf7 30. Ng5+ hxg5 31. Bg7 Nxg7 32. f3 Nf6 33. Kg2 Qe3 34. Kh3 g4+ 0-1	Gardo	sonie	1627	1806	Rated Bullet game	https://lichess.org/5dpjox73	2012-12-31 00:00:00	0-1	5dpjox73	2026-02-28 11:16:05.152
b5254822-0ed4-4620-badc-c98df0c620c5	[Event "Rated Blitz game"]\n[Site "https://lichess.org/86f04fbi"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Kyklades"]\n[Black "Mariss"]\n[Result "1-0"]\n[UTCDate "2012.12.31"]\n[UTCTime "23:52:43"]\n[WhiteElo "1577"]\n[BlackElo "1755"]\n[WhiteRatingDiff "+17"]\n[BlackRatingDiff "-16"]\n[ECO "C26"]\n[Opening "Vienna Game: Stanley Variation"]\n[TimeControl "240+0"]\n[Termination "Normal"]\n\n1. e4 e5 2. Bc4 Nf6 3. Nc3 Bc5 4. Nf3 d6 5. d4 exd4 6. Nxd4 O-O 7. O-O Nc6 8. Be3 Nxd4 9. Bxd4 Bxd4 10. Qxd4 Qe7 11. Rfe1 Ng4 12. Rad1 Ne5 13. b3 Qg5 14. Re3 Nxc4 15. Qxc4 Be6 16. Qxc7 Rac8 17. Qa5 Rc5 18. Qb4 Rfc8 19. Nd5 Rxc2 20. Qxb7 Bxd5 21. exd5 Rc1 22. Ree1 R1c2 23. Rf1 Qf5 24. Rde1 Rxa2 25. Qe7 Qf6 26. Qe8+ 1-0	Kyklades	Mariss	1577	1755	Rated Blitz game	https://lichess.org/86f04fbi	2012-12-31 00:00:00	1-0	86f04fbi	2026-02-28 11:22:14.638
6d5fb904-8a18-4d57-9fa8-502d76b619d4	[Event "Rated Bullet game"]\n[Site "https://lichess.org/45wcuie0"]\n[Date "????.??.??"]\n[Round "?"]\n[White "schutzstaffel"]\n[Black "nujabes"]\n[Result "1-0"]\n[UTCDate "2012.12.31"]\n[UTCTime "23:56:31"]\n[WhiteElo "1859"]\n[BlackElo "1747"]\n[WhiteRatingDiff "+9"]\n[BlackRatingDiff "-9"]\n[ECO "B01"]\n[Opening "Scandinavian Defense"]\n[TimeControl "60+0"]\n[Termination "Normal"]\n\n1. e4 d5 2. e5 c5 3. Nf3 Nc6 4. Bb5 Bg4 5. Bxc6+ bxc6 6. O-O Qc7 7. d4 cxd4 8. Qxd4 Bxf3 9. gxf3 h5 10. Nc3 e6 11. f4 Ne7 12. Be3 Nf5 13. Qd2 h4 14. Ne2 h3 15. Kh1 Nh4 16. Ng3 a5 17. Qe2 c5 18. Qg4 d4 19. Bd2 Qc6+ 20. f3 Rb8 21. b3 Rb4 22. Bxb4 axb4 23. a3 bxa3 24. Rxa3 Be7 25. Ra7 g6 26. Rfa1 f5 27. Nxf5 gxf5 28. Qg3 Nxf3 29. Qg6+ Kf8 30. Ra8+ Bd8 31. Rxd8+ Qe8 32. Rxe8# 1-0	schutzstaffel	nujabes	1859	1747	Rated Bullet game	https://lichess.org/45wcuie0	2012-12-31 00:00:00	1-0	45wcuie0	2026-02-28 11:23:19.65
078ad0b7-7403-4539-af4b-963b6b041c20	[Event "Rated Bullet game"]\n[Site "https://lichess.org/ntdkj4et"]\n[Date "????.??.??"]\n[Round "?"]\n[White "ricodelacasita"]\n[Black "cheesedout"]\n[Result "1-0"]\n[UTCDate "2012.12.31"]\n[UTCTime "23:57:15"]\n[WhiteElo "1743"]\n[BlackElo "1827"]\n[WhiteRatingDiff "+14"]\n[BlackRatingDiff "-13"]\n[ECO "B40"]\n[Opening "Sicilian Defense: French Variation"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. e4 c5 2. Nf3 e6 3. Be2 d5 4. e5 f6 5. d3 fxe5 6. Nxe5 Nf6 7. d4 Nc6 8. Nxc6 bxc6 9. c3 Be7 10. O-O O-O 11. Be3 cxd4 12. Bxd4 c5 13. Be5 Bd6 14. Bxd6 Qxd6 15. c4 d4 16. Bf3 Rb8 17. Qe2 Re8 18. Rd1 e5 19. Nc3 e4 20. Nxe4 Nxe4 21. Bxe4 Bb7 22. f3 Qf4 23. Qd3 Bxe4 24. fxe4 Rxe4 25. Qf3 Qe5 26. Rf1 Qe7 27. Rad1 Rf8 28. Qg3 Rxf1+ 29. Rxf1 Re3 30. Qf4 h6 31. Qb8+ Kh7 32. Qf4 d3 33. Qf5+ g6 34. Qd5 Re6 35. Qxd3 h5 36. Qd5 Re5 37. Rf7+ Kh6 38. Qd2+ Re3 39. Rxe7 1-0	ricodelacasita	cheesedout	1743	1827	Rated Bullet game	https://lichess.org/ntdkj4et	2012-12-31 00:00:00	1-0	ntdkj4et	2026-02-28 11:23:51.207
22fc9667-a22a-4677-882f-a8ffcbfeab7f	[Event "Rated Classical game"]\n[Site "https://lichess.org/l4j967z8"]\n[Date "????.??.??"]\n[Round "?"]\n[White "peter2"]\n[Black "VanillaShamanilla"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:02:03"]\n[WhiteElo "1507"]\n[BlackElo "1617"]\n[WhiteRatingDiff "+14"]\n[BlackRatingDiff "-63"]\n[ECO "C28"]\n[Opening "Bishop's Opening: Vienna Hybrid"]\n[TimeControl "480+0"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nc3 Nc6 3. Bc4 Nf6 4. d3 Bb4 5. Bg5 d6 6. Qd2 Qe7 7. a3 Ba5 8. b4 Bb6 9. Nd5 Qd7 10. Nxf6+ gxf6 11. Be3 Bxe3 12. Qxe3 Nd4 13. Qd2 Rg8 14. g3 b6 15. Ne2 Nxe2 16. Qxe2 Bb7 17. Qh5 O-O-O 18. Qxf7 Qxf7 19. Bxf7 Rgf8 20. Bb3 f5 21. f3 f4 22. g4 Rf6 23. h4 d5 24. Rd1 dxe4 25. dxe4 Rxd1+ 26. Kxd1 h6 27. Ke2 Ba6+ 28. Kf2 c5 29. bxc5 bxc5 30. Bd5 Bc4 31. Bxc4 1-0	peter2	VanillaShamanilla	1507	1617	Rated Classical game	https://lichess.org/l4j967z8	2013-01-01 00:00:00	1-0	l4j967z8	2026-02-28 11:25:14.774
6d8350f9-08c4-4cdf-b53e-f6fa0f5a52e6	[Event "Rated Classical game"]\n[Site "https://lichess.org/m6c8eqiw"]\n[Date "????.??.??"]\n[Round "?"]\n[White "j-jorjik"]\n[Black "6WX"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:02:51"]\n[WhiteElo "1542"]\n[BlackElo "1404"]\n[WhiteRatingDiff "+8"]\n[BlackRatingDiff "-23"]\n[ECO "B01"]\n[Opening "Scandinavian Defense: Modern Variation #2"]\n[TimeControl "480+8"]\n[Termination "Normal"]\n\n1. e4 d5 2. exd5 Nf6 3. Nc3 Nxd5 4. Nxd5 Qxd5 5. b3 e5 6. Bb2 Nc6 7. Nf3 Bd6 8. Bc4 Qa5 9. Bc3 Qb6 10. a4 a5 11. Bb5 O-O 12. Bxc6 bxc6 13. O-O Re8 14. Ng5 Bf5 15. Qf3 Bg6 16. Rae1 h6 17. Ne4 Rad8 18. Nxd6 cxd6 19. d3 Qc5 20. Bb2 Qxc2 21. Re2 Qxd3 22. Re3 Qd5 23. Qxd5 cxd5 24. Rfe1 d4 25. Rf3 f6 26. Bc1 Rc8 27. Bd2 Ra8 28. g4 Bf7 29. h3 Reb8 30. Rb1 e4 31. Rf4 d5 32. h4 Rb4 33. Bxb4 axb4 34. Rd1 d3 35. Kf1 Kf8 36. Rd2 Ke7 37. f3 g5 38. hxg5 hxg5 39. Rf5 Be6 40. fxe4 Bxf5 41. exf5 Kd6 42. Rxd3 Ke5 43. Kf2 Kf4 44. Rd4+ Ke5 45. Ke3 Rc8 46. Rxb4 Rc3+ 47. Ke2 d4 48. a5 Rc1 49. Ra4 Rb1 50. a6 Rxb3 51. a7 Re3+ 52. Kd2 Rg3 53. a8=Q Rxg4 54. Ra5+ Kf4 55. Qb8+ Ke4 56. Qb7+ Kf4 57. Qc7+ Ke4 58. Qc6+ Kf4 59. Qd6+ Ke4 60. Qd5+ Kf4 61. Qxd4+ Kg3 62. Ra3+ Kh4 63. Qf2+ Rg3 64. Ra4+ Kh3 65. Qf1+ Kh2 66. Ke2 Rg1 67. Qf2+ Rg2 68. Qxg2+ Kxg2 69. Ke3 Kg3 70. Ra6 Kg4 71. Ke4 Kh4 72. Rxf6 Kg4 73. Rg6 Kh5 74. Ke5 g4 75. Rg7 Kh6 76. f6 Kh5 77. f7 Kh4 78. f8=Q Kg3 79. Qf4+ Kh4 80. Rh7# 1-0	j-jorjik	6WX	1542	1404	Rated Classical game	https://lichess.org/m6c8eqiw	2013-01-01 00:00:00	1-0	m6c8eqiw	2026-02-28 11:25:34.583
38d57805-9ea9-45e5-ac09-9ae1ba396079	[Event "Rated Bullet game"]\n[Site "https://lichess.org/ma7jbj30"]\n[Date "????.??.??"]\n[Round "?"]\n[White "namesnik"]\n[Black "t4nk"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:07:21"]\n[WhiteElo "1554"]\n[BlackElo "1564"]\n[WhiteRatingDiff "-11"]\n[BlackRatingDiff "+11"]\n[ECO "B07"]\n[Opening "Pirc Defense #5"]\n[TimeControl "0+1"]\n[Termination "Time forfeit"]\n\n1. e4 d6 2. d4 c6 3. Nf3 a6 4. c3 b6 5. Bd3 Qc7 6. Qe2 Bb7 7. O-O c5 8. dxc5 d5 9. exd5 Qxc5 10. g3 Bxd5 11. Bf4 Bb7 12. Nbd2 Qc6 13. Nb3 Qxf3 14. Qxf3 Bxf3 15. Rfe1 Bc6 16. Bc7 Nd7 17. Bc4 Rc8 18. Rad1 Rxc7 19. Re2 e6 20. Rde1 b5 21. Bd3 a5 22. Nd4 Bb7 23. Nxb5 Rc8 24. c4 Bc5 0-1	namesnik	t4nk	1554	1564	Rated Bullet game	https://lichess.org/ma7jbj30	2013-01-01 00:00:00	0-1	ma7jbj30	2026-02-28 11:26:46.78
95c236e5-3d65-4507-9579-d7036f9f3e6f	[Event "Rated Blitz game"]\n[Site "https://lichess.org/ipj01q20"]\n[Date "????.??.??"]\n[Round "?"]\n[White "airtsart"]\n[Black "chess345"]\n[Result "1/2-1/2"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:07:33"]\n[WhiteElo "1869"]\n[BlackElo "1649"]\n[WhiteRatingDiff "-4"]\n[BlackRatingDiff "+73"]\n[ECO "C01"]\n[Opening "French Defense: Exchange Variation"]\n[TimeControl "180+0"]\n[Termination "Normal"]\n\n1. e4 e6 2. d4 d5 3. exd5 exd5 4. Bd3 Nf6 5. Bg5 Bd6 6. Nc3 c6 7. Nge2 O-O 8. Qd2 Bg4 9. f3 Bh5 10. O-O-O Bg6 11. Rde1 b5 12. Bxg6 fxg6 13. Bf4 a5 14. Bxd6 Qxd6 15. Ng3 a4 16. Re2 b4 17. Nd1 b3 18. a3 Na6 19. Rhe1 Rfe8 20. Rxe8+ Rxe8 21. Rxe8+ Nxe8 22. Qa5 c5 23. dxc5 Nxc5 24. Nc3 bxc2 25. Kxc2 d4 26. Nce4 d3+ 27. Kd1 Nxe4 28. Nxe4 Qe6 29. Qxa4 h5 30. Ng5 Qe2+ 31. Kc1 Qe3+ 32. Kb1 Qxg5 33. Qxe8+ Kh7 34. Qe1 d2 35. Qe2 Qxg2 36. Qxg2 d1=Q+ 37. Ka2 Qd5+ 38. Ka1 Qd1+ 39. Ka2 Qd5+ 40. b3 Kh6 41. Kb2 g5 42. b4 g4 43. Qf2 Qxf3 44. Qd2+ Kg6 45. a4 h4 46. a5 g3 47. hxg3 hxg3 48. Qc2+ Qf5 49. Qc6+ Qf6+ 50. Qxf6+ Kxf6 51. a6 g2 52. a7 g1=Q 53. a8=Q Qd4+ 54. Kb3 Qd3+ 55. Ka4 Qc2+ 56. Ka3 Qc1+ 57. Kb3 Qb1+ 58. Kc4 Qc2+ 59. Kb5 Qd3+ 60. Kb6 Qc4 61. Qc6+ Qxc6+ 62. Kxc6 g5 63. b5 g4 64. b6 g3 65. b7 g2 66. b8=Q g1=Q 67. Qd8+ Ke5 68. Qe7+ Kf4 69. Qf6+ Kg3 70. Qg5+ Kf2 71. Qxg1+ Kxg1 1/2-1/2	airtsart	chess345	1869	1649	Rated Blitz game	https://lichess.org/ipj01q20	2013-01-01 00:00:00	1/2-1/2	ipj01q20	2026-02-28 11:27:11.806
81065b53-0332-456f-83ea-47c0b0a51c85	[Event "Rated Bullet game"]\n[Site "https://lichess.org/grcc15yt"]\n[Date "????.??.??"]\n[Round "?"]\n[White "namesnik"]\n[Black "t4nk"]\n[Result "1/2-1/2"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:08:35"]\n[WhiteElo "1543"]\n[BlackElo "1575"]\n[WhiteRatingDiff "+1"]\n[BlackRatingDiff "-1"]\n[ECO "A00"]\n[Opening "Gedult's Opening"]\n[TimeControl "0+1"]\n[Termination "Normal"]\n\n1. f3 c6 2. e4 b6 3. d4 a6 4. Ne2 Qc7 5. Ng3 Bb7 6. Be2 Qd8 7. O-O e6 8. Be3 Bd6 9. c4 Bxg3 10. hxg3 Qc7 11. Kh2 h5 12. Bf2 h4 13. Kg1 hxg3 14. Be1 d6 15. Qd3 Qe7 16. f4 Qh4 17. Qxg3 Qh1+ 18. Kf2 Qh4 19. Qxh4 Rxh4 20. Bd2 Rh7 21. Nc3 f6 22. Rh1 g6 23. Rxh7 Ne7 24. Rg7 Nd7 25. Rh7 Kf8 26. Rah1 Kg8 27. Rh8+ Kg7 28. Rxa8 Bxa8 29. Bf3 f5 30. g4 fxg4 31. Bxg4 g5 32. Bxe6 Kf6 33. Bxd7 Bb7 34. Be8 Bc8 35. Rh6+ Kg7 36. Rxd6 Kf8 37. Rxc6 Bd7 38. Bxd7 Nxc6 39. Bxc6 Ke7 40. d5 Kd6 41. fxg5 Kc5 42. g6 Kxc4 43. g7 Kd4 44. g8=Q Kd3 45. Qg3+ Kxd2 46. Qe3+ Kc2 47. Na4 b5 48. Qc3+ Kb1 49. Qd3+ Ka1 50. Qd1+ Kxa2 51. Qc2 bxa4 52. b3+ Ka3 53. bxa4 a5 54. Bb5 Kb4 55. Qc4+ Ka3 56. Ke2 Kb2 57. Kd2 Ka1 58. Qd4+ Ka2 59. Bc4+ Ka3 60. Qa1+ Kb4 61. Qb2+ Kc5 62. Qc3 Kd6 63. Ba6 Ke7 64. Ke3 Kd6 65. Qd4 Ke7 66. Kf4 Kf7 67. Qe5 Kf8 68. Kf5 Kf7 69. Qf6+ Ke8 70. Ke6 1/2-1/2	namesnik	t4nk	1543	1575	Rated Bullet game	https://lichess.org/grcc15yt	2013-01-01 00:00:00	1/2-1/2	grcc15yt	2026-02-28 11:28:28.27
ae904a1e-7d92-4b5b-9a06-82b41c4d967e	[Event "Rated Blitz game"]\n[Site "https://lichess.org/cnw6r6h7"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Danut68"]\n[Black "serge"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:14:42"]\n[WhiteElo "1552"]\n[BlackElo "1478"]\n[WhiteRatingDiff "+9"]\n[BlackRatingDiff "-9"]\n[ECO "C44"]\n[Opening "Scotch Game"]\n[TimeControl "300+0"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 Nc6 3. d4 d6 4. dxe5 Nxe5 5. Nxe5 dxe5 6. Qxd8+ Kxd8 7. Bc4 Ke8 8. O-O Nf6 9. f3 Bd6 10. Nc3 Kf8 11. Bg5 Nd7 12. Rad1 g6 13. f4 Kg7 14. f5 Re8 15. f6+ Kf8 16. Bh6+ Kg8 17. Nd5 c6 18. Ne3 b5 19. Bb3 a5 20. Rxd6 a4 21. Bxf7+ Kxf7 22. Rxc6 Bb7 23. Rc7 Bxe4 24. Rxd7+ Ke6 25. Rxh7 Rac8 26. f7 Red8 27. f8=Q Rxf8 1-0	Danut68	serge	1552	1478	Rated Blitz game	https://lichess.org/cnw6r6h7	2013-01-01 00:00:00	1-0	cnw6r6h7	2026-02-28 11:28:36.343
93ff3559-d965-4220-9ebf-0674c9fe72b0	[Event "Rated Bullet game"]\n[Site "https://lichess.org/rxcs2u38"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Batalha"]\n[Black "jlfs"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:13:36"]\n[WhiteElo "1231"]\n[BlackElo "1452"]\n[WhiteRatingDiff "-8"]\n[BlackRatingDiff "+10"]\n[ECO "A10"]\n[Opening "English Opening"]\n[TimeControl "120+0"]\n[Termination "Time forfeit"]\n\n1. c4 d6 2. Nf3 e5 3. e4 c5 4. Nc3 Nc6 5. Nd5 Be6 6. d3 Be7 7. Nxe7 Ngxe7 8. a3 Qd7 9. b4 O-O 10. Bd2 Nd4 11. Nxd4 cxd4 12. Be2 f5 13. exf5 Nxf5 14. h3 Nh4 15. g3 Ng2+ 16. Kf1 Qc6 17. f3 Ne3+ 18. Bxe3 dxe3 19. g4 Rf4 20. Kg2 Raf8 21. Rf1 Qe8 22. Qc1 Qg6 23. Qxe3 h5 0-1	Batalha	jlfs	1231	1452	Rated Bullet game	https://lichess.org/rxcs2u38	2013-01-01 00:00:00	0-1	rxcs2u38	2026-02-28 11:30:38.745
39cbdc2f-46a5-49fe-9bf2-1760508a5e9a	[Event "Rated Bullet game"]\n[Site "https://lichess.org/ag41m9rk"]\n[Date "????.??.??"]\n[Round "?"]\n[White "cheesedout"]\n[Black "nichiren1967"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:17:41"]\n[WhiteElo "1821"]\n[BlackElo "1740"]\n[WhiteRatingDiff "+9"]\n[BlackRatingDiff "-9"]\n[ECO "D20"]\n[Opening "Queen's Gambit Accepted"]\n[TimeControl "60+0"]\n[Termination "Normal"]\n\n1. d4 d5 2. c4 dxc4 3. Nc3 g6 4. Nf3 Bg7 5. Bg5 Nf6 6. e4 h6 7. Bh4 g5 8. Bg3 Bg4 9. e5 Nd5 10. Qc2 Bxf3 11. gxf3 Nxc3 12. Qxc3 e6 13. Bxc4 Nc6 14. O-O-O Qd7 15. d5 O-O-O 16. dxe6 Qe7 17. exf7 Rxd1+ 18. Rxd1 Nxe5 19. Re1 Nd3+ 20. Qxd3 Qxe1+ 21. Kc2 Rf8 22. Qf5+ Kb8 23. Qc5 Rd8 24. Qxc7+ Ka8 25. Qxd8# 1-0	cheesedout	nichiren1967	1821	1740	Rated Bullet game	https://lichess.org/ag41m9rk	2013-01-01 00:00:00	1-0	ag41m9rk	2026-02-28 11:30:51.388
c7a36624-3a4d-4c8a-9cf1-9d3c4e95e4b5	[Event "Rated Bullet game"]\n[Site "https://lichess.org/ib5fhpnl"]\n[Date "????.??.??"]\n[Round "?"]\n[White "cheesedout"]\n[Black "nichiren1967"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:20:58"]\n[WhiteElo "1839"]\n[BlackElo "1724"]\n[WhiteRatingDiff "+9"]\n[BlackRatingDiff "-8"]\n[ECO "D20"]\n[Opening "Queen's Gambit Accepted"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. d4 d5 2. c4 dxc4 3. Nc3 g6 4. Nf3 Bg7 5. Bg5 Nf6 6. e4 h6 7. Bh4 g5 8. Bg3 Bg4 9. e5 Nd5 10. Qc2 e6 11. O-O-O Bxf3 12. gxf3 Nc6 13. a3 a6 14. Bxc4 Qd7 15. Ne4 O-O-O 16. Nc5 Qe7 17. Bxa6 Nb6 18. Bb5 Kb8 19. Bxc6 bxc6 20. Na6+ Kb7 21. Nb4 Qd7 22. f4 Ra8 23. fxg5 hxg5 24. f4 g4 25. Bf2 f6 26. d5 exd5 27. Bxb6 cxb6 28. exf6 Bxf6 29. Rhe1 Rhe8 30. Rxe8 Rxe8 31. Qa4 Qd6 32. Qa6+ Kb8 33. Qxb6+ Kc8 34. Na6 1-0	cheesedout	nichiren1967	1839	1724	Rated Bullet game	https://lichess.org/ib5fhpnl	2013-01-01 00:00:00	1-0	ib5fhpnl	2026-02-28 11:31:56.945
a99be7fc-749c-4b01-a959-b89dd9d19f86	[Event "Rated Bullet game"]\n[Site "https://lichess.org/3qlyk55t"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Batalha"]\n[Black "t4nk"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:27:49"]\n[WhiteElo "1221"]\n[BlackElo "1518"]\n[WhiteRatingDiff "+29"]\n[BlackRatingDiff "-20"]\n[ECO "A00"]\n[Opening "Mieses Opening"]\n[TimeControl "0+1"]\n[Termination "Normal"]\n\n1. d3 e6 2. e3 f5 3. f3 g5 4. c3 g4 5. b3 h5 6. fxg4 h4 7. g3 h3 8. Nf3 fxg4 9. Ne5 d6 10. Qxg4 c6 11. Qg6+ Ke7 12. Qf7# 1-0	Batalha	t4nk	1221	1518	Rated Bullet game	https://lichess.org/3qlyk55t	2013-01-01 00:00:00	1-0	3qlyk55t	2026-02-28 11:34:48.927
7b55a173-d1b0-4452-8885-55c62f92bede	[Event "Rated Bullet game"]\n[Site "https://lichess.org/cnent7zf"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Krieg"]\n[Black "t4nk"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:31:17"]\n[WhiteElo "1629"]\n[BlackElo "1509"]\n[WhiteRatingDiff "-14"]\n[BlackRatingDiff "+16"]\n[ECO "A40"]\n[Opening "Horwitz Defense"]\n[TimeControl "0+1"]\n[Termination "Time forfeit"]\n\n1. d4 e6 2. e3 e5 3. Nf3 e4 4. Ne5 f6 5. Nc4 d5 6. Ncd2 Bf5 7. c4 c6 8. cxd5 cxd5 9. b3 Qd6 10. Nc3 Qe6 11. g3 Bb4 12. Bb2 Nc6 13. Be2 a6 14. Bh5+ g6 15. Be2 h5 16. Na4 Nge7 17. Nc5 O-O 18. Nxe6 Bxe6 19. O-O f5 20. Bxh5 Rae8 21. Bxg6 Nxg6 22. Qh5 Kg7 23. Qg5 Rh8 24. Qe7+ Rxe7 0-1	Krieg	t4nk	1629	1509	Rated Bullet game	https://lichess.org/cnent7zf	2013-01-01 00:00:00	0-1	cnent7zf	2026-02-28 11:36:54.851
afb159c5-9ac9-4b13-aab8-2c3ef7f591d6	[Event "Rated Bullet game"]\n[Site "https://lichess.org/iwz4x6w4"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Krieg"]\n[Black "t4nk"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:35:02"]\n[WhiteElo "1631"]\n[BlackElo "1508"]\n[WhiteRatingDiff "+7"]\n[BlackRatingDiff "-8"]\n[ECO "D00"]\n[Opening "Queen's Pawn Game #2"]\n[TimeControl "0+1"]\n[Termination "Normal"]\n\n1. d4 d5 2. e3 e5 3. Nf3 exd4 4. Nxd4 c5 5. Nf3 c4 6. Be2 d4 7. O-O dxe3 8. Bxe3 Qxd1 9. Rxd1 Nd7 10. Bxc4 Ndf6 11. Bxf7+ Kxf7 12. c3 Ne7 13. Nbd2 Nfd5 14. Nb3 Nxe3 15. fxe3 Bg4 16. Nfd4 Ke8 17. Re1 Rd8 18. h3 Bh5 19. g4 Bg6 20. Kg2 Be4+ 21. Kg3 Bd5 22. Nf5 Nxf5+ 23. gxf5 Bd6+ 24. Kf2 Bxb3 25. axb3 b5 26. b4 Rc8 27. Rxa7 Bc7 28. e4 Bb8 29. Rb7 Rc7 30. Rxb5 Ba7+ 31. Kf3 g6 32. Re5+ Kd8 33. Rd1+ Kc8 34. Re6 Rd8 35. Rxd8+ Kxd8 36. Rd6+ Kc8 37. Ra6 Kb8 38. fxg6 hxg6 39. Rxg6 Rf7+ 40. Kg3 Kb7 41. Rg4 Bb8+ 42. Kg2 Rd7 43. Rg5 Rd2+ 44. Kf3 Rxb2 45. Ke3 Ba7+ 46. Kd3 Rb1 47. Rd5 Rd1+ 48. Kc4 Rxd5 49. Kxd5 Kc7 50. e5 Kd7 51. c4 Ke7 52. c5 Bb8 53. c6 Bc7 54. b5 Kd8 55. h4 Ba5 56. h5 Bd2 57. b6 Be3 58. b7 Bb6 59. b8=Q+ Ke7 60. Qxb6 Kf7 61. Qb7+ Kg8 62. e6 Kf8 63. e7+ Ke8 64. Qc8+ Kxe7 65. Qd7+ Kf6 66. c7 Kg5 67. c8=Q Kxh5 68. Qc4 Kg5 69. Qe6 Kh5 70. Kd4 Kg5 71. Qcd5+ Kf4 72. Qdd7 Kg3 73. Qg4+ Kf2 74. Qdf5+ Ke1 75. Qge4+ Kd2 76. Qd3+ Kc1 77. Qff1+ Kb2 78. Qfb1# 1-0	Krieg	t4nk	1631	1508	Rated Bullet game	https://lichess.org/iwz4x6w4	2013-01-01 00:00:00	1-0	iwz4x6w4	2026-02-28 11:38:56.146
142d3e0a-eaed-406d-ac06-b44468d50c74	[Event "Rated Classical game"]\n[Site "https://lichess.org/s3nr0v8a"]\n[Date "????.??.??"]\n[Round "?"]\n[White "TheWeebles"]\n[Black "ADRNLNNJECTD"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:39:20"]\n[WhiteElo "1562"]\n[BlackElo "1556"]\n[WhiteRatingDiff "-16"]\n[BlackRatingDiff "+11"]\n[ECO "A00"]\n[Opening "Van't Kruijs Opening"]\n[TimeControl "480+0"]\n[Termination "Time forfeit"]\n\n1. e3 c5 2. e4 d6 3. Nf3 Nc6 4. d4 cxd4 5. Nxd4 Nf6 6. Nc3 e5 7. Nb3 h6 8. Be2 g5 9. O-O Be6 10. Be3 d5 11. exd5 Nxd5 12. Nxd5 Bxd5 13. Bf3 Bxf3 14. Qxf3 Bg7 15. Rfd1 Qc7 16. Nc5 O-O 17. c4 b6 18. Ne4 Nb4 19. b3 Nc2 20. Rac1 Nxe3 21. fxe3 f5 22. Ng3 e4 23. Qh5 Qc5 24. Nf1 Rad8 25. Kh1 Rxd1 26. Rxd1 Kh7 27. Rd5 Qa3 28. h4 Qxa2 29. hxg5 Qb1 30. g6+ Kg8 31. Rxf5 Qxb3 32. Rxf8+ Kxf8 33. Qf5+ Kg8 34. Qf7+ Kh8 35. Ng3 Qd1+ 36. Kh2 Qd8 37. Kh3 Qf6 38. Nf5 Qxf7 39. gxf7 Kh7 40. Nxg7 Kxg7 41. Kg4 Kxf7 42. Kf5 a5 43. Kxe4 a4 44. Kd3 a3 45. Kc2 Kf6 46. Kb3 Kg5 47. Kxa3 h5 48. Kb4 Kg4 49. Kb5 h4 50. Kxb6 Kg3 51. c5 Kxg2 52. c6 h3 53. c7 h2 54. c8=Q h1=Q 55. Qg4+ Kf2 56. Qe4 Qxe4 0-1	TheWeebles	ADRNLNNJECTD	1562	1556	Rated Classical game	https://lichess.org/s3nr0v8a	2013-01-01 00:00:00	0-1	s3nr0v8a	2026-02-28 11:39:53.971
98b3ea45-e976-4855-a0e4-626bc61bc4eb	[Event "Rated Blitz game"]\n[Site "https://lichess.org/6n7axl08"]\n[Date "????.??.??"]\n[Round "?"]\n[White "vivelafete"]\n[Black "Luminosity"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:40:35"]\n[WhiteElo "1861"]\n[BlackElo "1853"]\n[WhiteRatingDiff "+13"]\n[BlackRatingDiff "-11"]\n[ECO "A40"]\n[Opening "Queen's Pawn"]\n[TimeControl "180+0"]\n[Termination "Normal"]\n\n1. d4 c6 2. f4 d5 3. Nf3 Bf5 4. Ne5 Nf6 5. e3 e6 6. Bd3 Bxd3 7. Qxd3 Nfd7 8. Qe2 Bd6 9. O-O f6 10. Qh5+ g6 11. Nxg6 hxg6 12. Qxh8+ Ke7 13. Qh7+ Kf8 14. Qxg6 Qe7 15. Nd2 Na6 16. c3 Nc7 17. Nf3 Ne8 18. Nh4 Ng7 19. b4 Qf7 20. Qd3 Re8 21. g3 b6 22. a4 c5 23. Ba3 cxb4 24. Bxb4 a5 25. Bxd6+ Kg8 1-0	vivelafete	Luminosity	1861	1853	Rated Blitz game	https://lichess.org/6n7axl08	2013-01-01 00:00:00	1-0	6n7axl08	2026-02-28 11:40:22.521
500cb63e-f18f-4776-acd0-c6db605d94b7	[Event "Rated Classical game"]\n[Site "https://lichess.org/eyda5jr4"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Rambo007max"]\n[Black "mufasa"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:45:11"]\n[WhiteElo "1584"]\n[BlackElo "1663"]\n[WhiteRatingDiff "-9"]\n[BlackRatingDiff "+8"]\n[ECO "B20"]\n[Opening "Sicilian Defense: Bowdler Attack"]\n[TimeControl "600+6"]\n[Termination "Normal"]\n\n1. e4 c5 2. Bc4 e6 3. d4 cxd4 4. Qxd4 Nc6 5. Qd3 Nf6 6. Nf3 a6 7. O-O b5 8. Bb3 Na5 9. Bg5 h6 10. Bh4 g5 11. Bg3 Bb7 12. Re1 g4 13. Nd4 d6 14. Bh4 e5 15. Nf5 Be7 16. Bxf6 Bxf6 17. Nxd6+ Ke7 18. Nf5+ Ke8 19. Bd5 Bxd5 20. Qxd5 Qxd5 21. exd5 Nc4 22. b3 Nb6 23. Nc3 e4 24. Rxe4+ Kd7 25. Re3 Nxd5 26. Rd1 Bxc3 27. Rxc3 Ke6 28. Nd4+ Kf6 29. Rc6+ Kg5 30. Ne2 Nb4 31. Rc5+ f5 32. a3 Na2 33. Ra1 Rhe8 34. Kf1 Rad8 35. Nc3 Nxc3 36. Rxc3 Rd2 37. Rc5 Ree2 38. h4+ Kxh4 39. Rxf5 g3 40. Rf4+ Kg5 41. fxg3 Rxg2 42. Re1 Rxg3 43. Rf2 Rxf2+ 44. Kxf2 Rc3 45. Re2 h5 46. Rd2 h4 47. Kg2 a5 48. Rd5+ Kg4 49. Rxb5 Rxc2+ 50. Kf1 Kf3 51. Re5 Rc3 52. b4 Rxa3 53. b5 Rb3 54. Rh5 Rb1# 0-1	Rambo007max	mufasa	1584	1663	Rated Classical game	https://lichess.org/eyda5jr4	2013-01-01 00:00:00	0-1	eyda5jr4	2026-02-28 11:41:20.415
00b0a79f-e275-4a00-847b-675b89959cf4	[Event "Rated Bullet game"]\n[Site "https://lichess.org/i1wt52od"]\n[Date "????.??.??"]\n[Round "?"]\n[White "namesnik"]\n[Black "cheesedout"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:50:31"]\n[WhiteElo "1516"]\n[BlackElo "1896"]\n[WhiteRatingDiff "-3"]\n[BlackRatingDiff "+3"]\n[ECO "A00"]\n[Opening "Van't Kruijs Opening"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. e3 c5 2. d4 e6 3. dxc5 Bxc5 4. Nf3 Be7 5. Bc4 Nf6 6. b3 Nc6 7. Bb2 O-O 8. O-O d5 9. Bd3 Bd6 10. h4 e5 11. e4 dxe4 12. Bxe4 Nxe4 13. Qd3 Nf6 14. Nbd2 Re8 15. g4 e4 16. Nxe4 Nxe4 17. Rfe1 Nf6 18. g5 Rxe1+ 19. Rxe1 Nh5 20. Nd4 Nxd4 21. Qxd4 Qc7 22. Re8+ Bf8 0-1	namesnik	cheesedout	1516	1896	Rated Bullet game	https://lichess.org/i1wt52od	2013-01-01 00:00:00	0-1	i1wt52od	2026-02-28 11:43:29.906
34e2a088-046a-4101-b005-d7d4a406e884	[Event "Rated Blitz game"]\n[Site "https://lichess.org/24o7a5mw"]\n[Date "????.??.??"]\n[Round "?"]\n[White "sport"]\n[Black "DangerCat"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "00:58:21"]\n[WhiteElo "1487"]\n[BlackElo "1640"]\n[WhiteRatingDiff "+15"]\n[BlackRatingDiff "-16"]\n[ECO "C00"]\n[Opening "French Defense #2"]\n[TimeControl "300+3"]\n[Termination "Normal"]\n\n1. e4 e6 2. Bc4 d5 3. exd5 exd5 4. Qe2+ Be7 5. Bb3 Nf6 6. d3 h6 7. Bxh6 gxh6 8. Nc3 Bg4 9. f3 Be6 10. O-O-O Nc6 11. d4 Qd7 12. a4 O-O-O 13. Nh3 Bxh3 14. gxh3 Qxh3 15. Kd2 Rhe8 16. Ra1 Nxd4 17. Qd3 Nxf3+ 18. Kc1 Ng5 19. Qd4 c6 20. Qxa7 Bd6 21. a5 Qf3 22. Rd1 Bxh2 23. a6 bxa6 24. Rxa6 Qf4+ 25. Kb1 Qd6 26. Bxd5 Nxd5 27. Nxd5 cxd5 28. Rxd6 Bxd6 29. Rd3 Be5 30. Rb3 f6 31. Qb7# 1-0	sport	DangerCat	1487	1640	Rated Blitz game	https://lichess.org/24o7a5mw	2013-01-01 00:00:00	1-0	24o7a5mw	2026-02-28 11:45:05.366
beeb4f4b-9a80-4d45-acc1-d2cfb4bc4514	[Event "Rated Bullet game"]\n[Site "https://lichess.org/diqhnj15"]\n[Date "????.??.??"]\n[Round "?"]\n[White "moonwalker"]\n[Black "-jack69-"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "01:37:16"]\n[WhiteElo "2007"]\n[BlackElo "1931"]\n[WhiteRatingDiff "-18"]\n[BlackRatingDiff "+34"]\n[ECO "D37"]\n[Opening "Queen's Gambit Declined: Harrwitz Attack, Orthodox Defense"]\n[TimeControl "120+0"]\n[Termination "Normal"]\n\n1. d4 e6 2. c4 d5 3. Nc3 Be7 4. Nf3 Nf6 5. Bf4 O-O 6. e3 c6 7. h3 Nbd7 8. c5 Re8 9. b4 a5 10. a3 Ne4 11. Nxe4 dxe4 12. Ne5 Nxe5 13. Bxe5 f6 14. Bg3 Bf8 15. Qc2 axb4 16. Qxe4 Qd5 17. Qc2 Kh8 18. Rd1 bxa3 19. e4 Qd7 20. Bc4 Qd8 21. O-O Qa5 22. Ra1 e5 23. dxe5 fxe5 24. Bb3 Bxc5 25. Kh2 Bd4 26. Ra2 Be6 27. Bxe6 Rxe6 28. f4 Ree8 29. fxe5 Bxe5 30. Bxe5 Qxe5+ 31. Kh1 Qxe4 32. Qb3 Qd5 33. Qc2 b5 34. Rd1 Qe4 35. Qb3 b4 36. Rc1 Qd5 37. Rc4 Re1+ 38. Kh2 Qe5+ 39. Qg3 Qxg3+ 40. Kxg3 b3 41. Rxa3 Rxa3 42. Rxc6 b2+ 43. Kf2 Re8 44. Rb6 Ra2 45. Kg1 h6 46. Kh2 Kh7 47. Rb4 Re1 48. Rb3 b1=Q 49. Rb4 Qxb4 50. h4 Qb2 51. Kg3 Qxg2+ 52. Kf4 Rf1+ 53. Ke5 Qe2+ 54. Kd6 Rd1+ 55. Kc5 Qc2+ 56. Kb4 Rb1# 0-1	moonwalker	-jack69-	2007	1931	Rated Bullet game	https://lichess.org/diqhnj15	2013-01-01 00:00:00	0-1	diqhnj15	2026-02-28 11:54:29.782
e6bacf32-dbb3-4892-ab00-5d2a44273e55	[Event "Rated Blitz game"]\n[Site "https://lichess.org/2woqygsw"]\n[Date "????.??.??"]\n[Round "?"]\n[White "ptdhina"]\n[Black "vivelafete"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "01:42:58"]\n[WhiteElo "1750"]\n[BlackElo "1851"]\n[WhiteRatingDiff "-8"]\n[BlackRatingDiff "+9"]\n[ECO "C00"]\n[Opening "French Defense: Knight Variation"]\n[TimeControl "300+0"]\n[Termination "Time forfeit"]\n\n1. e4 e6 2. Nf3 c6 3. Bc4 d5 4. exd5 cxd5 5. Bb3 Nf6 6. d4 h6 7. a3 Bd6 8. O-O Nc6 9. Re1 O-O 10. Ne5 Qc7 11. Bf4 Nd7 12. Nxd7 Bxd7 13. Bxd6 Qxd6 14. c4 dxc4 15. Bxc4 a6 16. Nc3 b5 17. Ba2 Ne7 18. Ne4 Qc6 19. Qf3 Nd5 20. Rec1 Qb6 21. Bxd5 exd5 22. Nc5 Be6 23. Re1 a5 24. Qg3 b4 25. Nxe6 fxe6 26. axb4 axb4 27. Rxa8 Rxa8 28. h3 Ra6 29. Qg6 Qxd4 30. Rxe6 Rxe6 31. Qxe6+ Kh8 32. b3 Qc5 33. Qe5 Qc1+ 34. Kh2 Qc5 35. f4 Kh7 36. f5 Qc6 37. Qd4 Qd6+ 38. g3 h5 39. h4 Kh6 40. Kg2 Qc6 41. Kf3 g6 42. f6 Qe6 43. f7 Qxf7+ 44. Ke3 Qe6+ 45. Kd3 Qf5+ 46. Kd2 Qe6 47. Qxb4 g5 48. hxg5+ Kxg5 49. Qf4+ Kg6 50. Kd3 Qc6 51. Kd4 Qb6+ 52. Kc3 Qc5+ 53. Kb2 d4 54. Qe4+ Kg7 55. Qd3 Kf6 56. Qf3+ Ke6 57. Qe4+ Kd6 58. Qg6+ Kc7 59. Qf7+ Kb6 60. Qe6+ Kb5 61. Qc4+ Qxc4 62. bxc4+ Kxc4 63. Kc2 d3+ 64. Kd2 Kd4 0-1	ptdhina	vivelafete	1750	1851	Rated Blitz game	https://lichess.org/2woqygsw	2013-01-01 00:00:00	0-1	2woqygsw	2026-02-28 11:56:03.953
5186ccb2-05a8-410c-8ece-6c7bf864b432	[Event "Rated Bullet game"]\n[Site "https://lichess.org/txk4qm2h"]\n[Date "????.??.??"]\n[Round "?"]\n[White "t4nk"]\n[Black "cheesedout"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "01:53:56"]\n[WhiteElo "1503"]\n[BlackElo "1878"]\n[WhiteRatingDiff "-3"]\n[BlackRatingDiff "+4"]\n[ECO "A00"]\n[Opening "Van't Kruijs Opening"]\n[TimeControl "0+1"]\n[Termination "Normal"]\n\n1. e3 c5 2. Bb5 e6 3. Qe2 a6 4. Ba4 b5 5. Bb3 d5 6. c3 Nf6 7. Bc2 Be7 8. Bd1 O-O 9. Qd3 Nc6 10. Be2 c4 11. Qc2 e5 12. d3 cxd3 13. Bxd3 d4 14. Qd1 dxe3 15. Bxe3 Bg4 16. Be2 Bxe2 17. Qxe2 Qc7 18. Qd1 Rad8 19. Qe2 Ne4 20. Nf3 Na5 21. Nbd2 Nxd2 22. Nxd2 Nc4 23. Nxc4 bxc4 24. O-O Bf6 25. Rfd1 Rxd1+ 26. Qxd1 e4 27. Qe2 Be5 28. Rd1 Bxh2+ 29. Kf1 Bf4 30. Bxf4 Qxf4 31. g3 Qh6 32. f3 Qh1+ 33. Kf2 Qh2+ 34. Ke3 Qxg3 35. Qxc4 Qxf3+ 36. Kd4 Rd8+ 37. Kc5 Qxd1 38. Qxa6 Qd5+ 39. Kb4 Rb8+ 40. Ka3 Qb5 41. b3 Qxa6+ 42. Kb2 Qd3 43. a3 e3 44. c4 e2 45. b4 e1=Q 46. c5 Qec3+ 47. Ka2 Qdc2# 0-1	t4nk	cheesedout	1503	1878	Rated Bullet game	https://lichess.org/txk4qm2h	2013-01-01 00:00:00	0-1	txk4qm2h	2026-02-28 11:57:58.487
ad5546be-050b-4167-aea0-2aa66709b1dc	[Event "Rated Bullet game"]\n[Site "https://lichess.org/hbzk28yq"]\n[Date "????.??.??"]\n[Round "?"]\n[White "LEGENDARY_ERFAN"]\n[Black "RookieRook"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:10:41"]\n[WhiteElo "1444"]\n[BlackElo "1507"]\n[WhiteRatingDiff "-27"]\n[BlackRatingDiff "+9"]\n[ECO "B06"]\n[Opening "Modern Defense"]\n[TimeControl "60+0"]\n[Termination "Normal"]\n\n1. e4 g6 2. Bc4 Bg7 3. d3 e6 4. Nf3 Nf6 5. O-O d5 6. exd5 Nxd5 7. Bxd5 Qxd5 8. Nc3 Qd8 9. h3 Nd7 10. Re1 b6 11. Bf4 Bb7 12. Bg5 Nf6 13. Re5 O-O 14. a3 Qd7 15. Bxf6 Bxf6 16. Re4 Bxe4 17. dxe4 Bg7 18. Qxd7 Rad8 19. Qxc7 Rd2 20. Rd1 Rxc2 21. Nd4 Rxb2 22. Nc6 Rc2 23. Nb5 Bf6 24. Rd8 Rxd8 25. Nxd8 Rxc7 26. Nc6 Rxc6 27. Nxa7 Rc5 28. a4 Bd4 29. g3 Rc1+ 30. Kg2 b5 31. h4 Bxa7 32. e5 bxa4 33. h5 Bd4 34. g4 Bxe5 35. Kh3 Bd4 36. g5 Rc2 37. Kh4 Rxf2 38. Kh3 Rf5 39. Kh4 Bf2+ 40. Kh3 Rxg5 41. Kh2 Rxh5+ 42. Kg2 Bc5 43. Kf3 Be7 44. Ke2 a3 45. Kd3 Rb5 46. Kc2 a2 47. Kd2 Rb8 48. Kd3 a1=Q 49. Ke3 Qc3+ 50. Ke2 Rb2+ 51. Kf1 Qc1# 0-1	LEGENDARY_ERFAN	RookieRook	1444	1507	Rated Bullet game	https://lichess.org/hbzk28yq	2013-01-01 00:00:00	0-1	hbzk28yq	2026-02-28 12:02:25.636
1c3c0dd0-9260-43f8-b08c-128f570be6a5	[Event "Rated Classical game"]\n[Site "https://lichess.org/uoit0jvt"]\n[Date "????.??.??"]\n[Round "?"]\n[White "TheWeebles"]\n[Black "rasmussenesq"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:10:44"]\n[WhiteElo "1581"]\n[BlackElo "1594"]\n[WhiteRatingDiff "-13"]\n[BlackRatingDiff "+11"]\n[ECO "B45"]\n[Opening "Sicilian Defense: Paulsen Variation, Normal Variation"]\n[TimeControl "480+0"]\n[Termination "Normal"]\n\n1. e4 c5 2. Nf3 e6 3. d4 cxd4 4. Nxd4 Nc6 5. Nc3 Bb4 6. Be3 Nge7 7. a3 Ba5 8. Be2 O-O 9. O-O d5 10. b4 Bb6 11. Nxc6 bxc6 12. exd5 Nxd5 13. Nxd5 Qxd5 14. Qxd5 exd5 15. Bxb6 axb6 16. c4 Be6 17. Rfc1 d4 18. c5 bxc5 19. Rxc5 Rac8 20. Rac1 Bd5 21. Bd3 Ra8 22. Ra1 Rfe8 23. Bc4 Bxc4 24. Rxc4 Red8 25. Rxc6 d3 26. Kf1 d2 27. Ke2 Ra7 28. a4 Re7+ 29. Kf1 d1=Q+ 30. Rxd1 Rxd1# 0-1	TheWeebles	rasmussenesq	1581	1594	Rated Classical game	https://lichess.org/uoit0jvt	2013-01-01 00:00:00	0-1	uoit0jvt	2026-02-28 12:02:33.946
23deb475-48e7-4b64-8b37-a0daf3b3018d	[Event "Rated Bullet game"]\n[Site "https://lichess.org/59wgft1t"]\n[Date "????.??.??"]\n[Round "?"]\n[White "ptdhina"]\n[Black "namesnik"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:15:47"]\n[WhiteElo "1554"]\n[BlackElo "1502"]\n[WhiteRatingDiff "-15"]\n[BlackRatingDiff "+14"]\n[ECO "B01"]\n[Opening "Scandinavian Defense: Mieses-Kotroc Variation"]\n[TimeControl "120+0"]\n[Termination "Time forfeit"]\n\n1. e4 d5 2. exd5 Qxd5 3. Nf3 Nf6 4. Nc3 Qa5 5. d4 c6 6. Bd2 Qc7 7. Bc4 Bg4 8. h3 Bh5 9. g4 Bg6 10. Ne5 Nbd7 11. Bf4 Nxe5 12. dxe5 Ne4 13. Qf3 Nxc3 14. bxc3 e6 15. Bd3 Bc5 16. O-O O-O 17. Be3 Bxe3 18. fxe3 Rad8 19. Be4 Qa5 20. h4 Bxe4 21. Qxe4 Qxc3 22. h5 Rd2 23. g5 Qxc2 24. Qf3 Rfd8 25. g6 fxg6 26. hxg6 Rh2 0-1	ptdhina	namesnik	1554	1502	Rated Bullet game	https://lichess.org/59wgft1t	2013-01-01 00:00:00	0-1	59wgft1t	2026-02-28 12:03:39.561
bf2ba10f-b1a0-4c36-bb8c-223264345a63	[Event "Rated Classical game"]\n[Site "https://lichess.org/k0u8853r"]\n[Date "????.??.??"]\n[Round "?"]\n[White "khan"]\n[Black "Melinda"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:18:01"]\n[WhiteElo "1434"]\n[BlackElo "1707"]\n[WhiteRatingDiff "-4"]\n[BlackRatingDiff "+5"]\n[ECO "D02"]\n[Opening "Queen's Pawn Game: Zukertort Variation"]\n[TimeControl "300+8"]\n[Termination "Normal"]\n\n1. Nf3 d5 2. d4 e6 3. Nc3 c5 4. Bf4 Nc6 5. Nb5 Qb6 6. Nc7+ Kd7 7. Nxa8 Qxb2 8. Qb1 Qc3+ 9. Bd2 Qc4 10. e3 Qa4 11. Qb3 Qxb3 12. axb3 cxd4 13. Bb5 Bd6 14. Bxc6+ Kxc6 15. Nxd4+ Kd7 16. Rxa7 Nf6 17. Nb6+ Kc7 18. Nxc8 Rxc8 19. Nb5+ Kc6 20. Nxd6 Kxd6 21. c3 Rc7 22. Ke2 Nd7 23. Rha1 Nc5 24. b4 Nd7 25. Ra8 Nb6 26. Rh8 h6 27. Rg8 f6 28. Rd8+ Ke7 29. Rg8 Kf7 30. Rga8 Nxa8 31. Rxa8 Ke7 32. Rg8 Kf7 33. Rb8 Ke7 34. f4 Kf7 35. g4 Kg6 36. h4 h5 37. Kf3 hxg4+ 38. Kxg4 f5+ 39. Kg3 Kf6 40. h5 Ke7 41. Rg8 Kf7 42. Rb8 Kf6 43. Kh4 Rd7 44. Rc8 Kf7 45. Kg5 b5 46. Rb8 Ra7 47. Rxb5 Ra1 48. Bc1 Rxc1 49. Rb7+ Kg8 50. Rb6 Kf7 51. Rb7+ Kg8 52. Rb6 Kf7 53. Rb7+ Kg8 54. Rc7 Rg1+ 55. Kh4 Re1 56. c4 dxc4 57. Rxc4 Rxe3 58. b5 Rb3 59. Rc5 Kf7 60. Kg5 Rg3+ 61. Kh4 Rg4+ 62. Kh3 Rxf4 63. Rc7+ Kf6 64. b6 Rb4 65. b7 Rb3+ 66. Kg2 e5 67. Rc6+ Kg5 68. Rc7 Kxh5 69. Rxg7 e4 70. Rh7+ Kg5 71. Rg7+ Kf4 72. Rf7 Rb2+ 73. Kf1 Kg4 74. Ke1 e3 75. Rg7+ Kf3 76. Rf7 Rb1# 0-1	khan	Melinda	1434	1707	Rated Classical game	https://lichess.org/k0u8853r	2013-01-01 00:00:00	0-1	k0u8853r	2026-02-28 12:04:26.483
03c99112-0d29-4cc3-a7e2-c66ef88ea4eb	[Event "Rated Classical game"]\n[Site "https://lichess.org/5ysdq1vq"]\n[Date "????.??.??"]\n[Round "?"]\n[White "IsraelCravchik"]\n[Black "shueardm"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:21:43"]\n[WhiteElo "1334"]\n[BlackElo "1273"]\n[WhiteRatingDiff "-14"]\n[BlackRatingDiff "+24"]\n[ECO "C42"]\n[Opening "Russian Game: Three Knights Game"]\n[TimeControl "600+0"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 Nf6 3. Nc3 a6 4. d4 Bb4 5. dxe5 Bxc3+ 6. bxc3 Nxe4 7. Ba3 Nxc3 8. Qd3 Nb5 9. O-O-O f6 10. Qe4 Nxa3 11. Bc4 Nxc4 12. Qxc4 fxe5 13. Nxe5 Rf8 14. Rhe1 Qg5+ 15. f4 Qxf4+ 16. Qxf4 Rxf4 17. Ng6+ Kf7 18. Nxf4 g5 19. Nd5 Nc6 20. Rf1+ Kg6 21. Ne7+ Nxe7 22. Rde1 Nf5 23. Re4 d5 24. Re5 d4 25. g4 Ne3 26. Rf8 Nxg4 27. Rg8+ Kf6 28. Rexg5 Nxh2 29. Rg2 Ng4 30. Rf8+ Ke7 31. Rf4 c5 32. Re4+ Kf6 33. Rg3 h6 34. Rf3+ Kg6 35. Ref4 Be6 36. Rf6+ Nxf6 0-1	IsraelCravchik	shueardm	1334	1273	Rated Classical game	https://lichess.org/5ysdq1vq	2013-01-01 00:00:00	0-1	5ysdq1vq	2026-02-28 12:05:57.855
4f543547-b5ab-43fe-ab18-fd15d07faf37	[Event "Rated Bullet game"]\n[Site "https://lichess.org/m990ldys"]\n[Date "????.??.??"]\n[Round "?"]\n[White "cheesedout"]\n[Black "Hephesto"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:23:01"]\n[WhiteElo "1826"]\n[BlackElo "1879"]\n[WhiteRatingDiff "+17"]\n[BlackRatingDiff "-15"]\n[ECO "D31"]\n[Opening "Queen's Gambit Declined: Queen's Knight Variation"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. d4 d5 2. c4 e6 3. Nc3 Bb4 4. Nf3 Bxc3+ 5. bxc3 c6 6. Bg5 f6 7. Bh4 Qa5 8. Qc2 Ne7 9. e3 Nf5 10. Bg3 Nd7 11. Bd3 Nxg3 12. hxg3 Nb6 13. c5 Nc4 14. Bxc4 dxc4 15. O-O O-O 16. e4 e5 17. d5 cxd5 18. exd5 Qxc5 19. Rad1 Rd8 20. Rd2 Rxd5 21. Rxd5 Qxd5 22. Rd1 Qe6 23. Nh4 Bd7 24. Nf3 Bc6 25. Nh4 e4 26. Qd2 Re8 27. Qe3 b5 28. Rd4 g5 29. Ng6 hxg6 30. Qd2 Kg7 31. Rd6 Qe7 32. Qd4 Ba8 33. Ra6 Qe5 34. Qd7+ Re7 35. Qd8 Bb7 36. Rxa7 e3 37. fxe3 Qxe3+ 38. Kh2 Qe2 39. Rxb7 Rxb7 40. Qd5 Qe7 41. Qf3 f5 42. g4 Kf6 43. Kg3 Qe5+ 44. Kf2 Re7 45. gxf5 Qe2+ 46. Kg3 Re6 47. Qxe2 Rxe2 48. Kf3 Kxf5 49. g3 Ke5 50. Kxe2 Kd5 51. Ke1 1-0	cheesedout	Hephesto	1826	1879	Rated Bullet game	https://lichess.org/m990ldys	2013-01-01 00:00:00	1-0	m990ldys	2026-02-28 12:06:36.107
e226d590-2378-4c7f-91a4-b7c6b87e47ba	[Event "Rated Classical game"]\n[Site "https://lichess.org/l1m4sg77"]\n[Date "????.??.??"]\n[Round "?"]\n[White "sebastian44"]\n[Black "Richard_XII"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:25:15"]\n[WhiteElo "1363"]\n[BlackElo "1482"]\n[WhiteRatingDiff "+15"]\n[BlackRatingDiff "-15"]\n[ECO "B02"]\n[Opening "Alekhine Defense: Maroczy Variation"]\n[TimeControl "300+5"]\n[Termination "Normal"]\n\n1. e4 Nf6 2. d3 d5 3. e5 Nfd7 4. d4 Nc6 5. Nf3 e6 6. Bb5 a6 7. Bxc6 bxc6 8. c3 c5 9. O-O c4 10. Bg5 f6 11. exf6 Nxf6 12. Bxf6 Qxf6 13. Ne5 Bd6 14. Re1 O-O 15. Nd2 Qxf2+ 16. Kh1 Bxe5 17. Rf1 Qh4 18. Rxf8+ Kxf8 19. dxe5 Qf4 20. Qe1 Bd7 21. g3 Qg5 22. Nf3 Qf5 23. Qf1 Kg8 24. Qg2 Be8 25. Rf1 Bh5 26. Nd4 Qxe5 27. Nc6 Qd6 28. Qh3 Qxc6 29. Qxh5 d4+ 30. Kg1 d3 31. Qf7+ Kh8 32. Qf8+ 1-0	sebastian44	Richard_XII	1363	1482	Rated Classical game	https://lichess.org/l1m4sg77	2013-01-01 00:00:00	1-0	l1m4sg77	2026-02-28 12:06:51.349
a487b77d-d378-44d1-81c2-0004289b1232	[Event "Rated Bullet game"]\n[Site "https://lichess.org/apgjpc1g"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Ben_Dover"]\n[Black "namesnik"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:32:14"]\n[WhiteElo "1893"]\n[BlackElo "1513"]\n[WhiteRatingDiff "-19"]\n[BlackRatingDiff "+22"]\n[ECO "A06"]\n[Opening "Zukertort Opening: Tennison Gambit"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. e4 d5 2. Nf3 dxe4 3. Ne5 Nc6 4. Nxc6 bxc6 5. Bc4 e6 6. O-O Bb7 7. Nc3 c5 8. Re1 Nf6 9. d4 exd3 10. cxd3 Be7 11. Be3 O-O 12. d4 cxd4 13. Bxd4 c5 14. Be3 Rc8 15. Qc2 Qc7 16. g3 Qc6 17. Kf1 Qg2+ 18. Ke2 Bf3+ 19. Kd2 Rfd8+ 20. Kc1 Qxh2 21. Ne2 Bxe2 22. Qxe2 Ne4 23. Bd3 c4 24. Bxe4 c3 25. Kc2 cxb2+ 26. Kxb2 Bf6+ 27. Kb3 Rb8+ 28. Ka3 Bxa1 29. Rxa1 Rd6 30. Bf4 Qh5 31. Qxh5 Ra6+ 0-1	Ben_Dover	namesnik	1893	1513	Rated Bullet game	https://lichess.org/apgjpc1g	2013-01-01 00:00:00	0-1	apgjpc1g	2026-02-28 12:07:56.873
f5779728-b667-4daf-b9d1-a661f39ae684	[Event "Rated Blitz game"]\n[Site "https://lichess.org/8ek0fqf3"]\n[Date "????.??.??"]\n[Round "?"]\n[White "crazy2013"]\n[Black "Naitero_Nagasaki"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:42:02"]\n[WhiteElo "1699"]\n[BlackElo "1831"]\n[WhiteRatingDiff "-24"]\n[BlackRatingDiff "+7"]\n[ECO "A40"]\n[Opening "Horwitz Defense"]\n[TimeControl "300+0"]\n[Termination "Normal"]\n\n1. d4 e6 2. Nd2 c5 3. Ngf3 cxd4 4. Nxd4 Nc6 5. e3 e5 6. Nf5 d5 7. b3 Bxf5 8. Nf3 e4 9. Nd4 Bg6 10. Bb2 Nf6 11. Bb5 Rc8 12. O-O Be7 13. f4 O-O 14. f5 Bh5 15. Qe1 Nxd4 16. Bxd4 Bc5 17. c3 Bxd4 18. cxd4 a6 19. Be2 Bxe2 20. Qxe2 Qa5 21. a4 Rc3 22. Qd2 Rfc8 23. Rac1 Qc7 24. Rb1 Rc2 25. Qe1 Qc3 26. Qg3 Qd2 27. Rfd1 Rc1 28. Qe1 Rxd1 29. Rxd1 Qxe1+ 30. Rxe1 Rc3 31. Kf2 Ng4+ 32. Kg3 Rxe3+ 33. Rxe3 Nxe3 34. Kf2 Nxf5 35. g4 Nxd4 36. Ke3 Nxb3 37. Kf4 Kf8 38. Ke5 e3 0-1	crazy2013	Naitero_Nagasaki	1699	1831	Rated Blitz game	https://lichess.org/8ek0fqf3	2013-01-01 00:00:00	0-1	8ek0fqf3	2026-02-28 12:09:40.462
c3330430-77c2-436f-a62c-bed19d9def89	[Event "Rated Bullet game"]\n[Site "https://lichess.org/ug66brmo"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Ben_Dover"]\n[Black "cheesedout"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "02:50:35"]\n[WhiteElo "1862"]\n[BlackElo "1885"]\n[WhiteRatingDiff "-9"]\n[BlackRatingDiff "+12"]\n[ECO "B40"]\n[Opening "Sicilian Defense: Marshall Counterattack"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. e4 c5 2. d4 e6 3. Nf3 d5 4. exd5 exd5 5. Bb5+ Nc6 6. O-O Nf6 7. Bg5 Be7 8. Ne5 O-O 9. Nxc6 bxc6 10. Bxc6 Rb8 11. Bxf6 Bxf6 12. c3 c4 13. Ba4 Bf5 14. b3 cxb3 15. Bxb3 Qd6 16. Qf3 Be4 17. Qe2 Bg5 18. Nd2 Bg6 19. Nf3 Rfe8 20. Qb2 Bf6 21. Rfe1 Bh5 22. Rxe8+ Rxe8 23. a4 Qf4 24. Ne5 Bxe5 25. dxe5 Qxe5 26. a5 Qg5 27. a6 Bf3 28. g3 Re2 29. Qa3 h6 0-1	Ben_Dover	cheesedout	1862	1885	Rated Bullet game	https://lichess.org/ug66brmo	2013-01-01 00:00:00	0-1	ug66brmo	2026-02-28 12:11:04.879
58f4b00d-fd1c-425d-9621-b6402a9aaa05	[Event "Rated Bullet game"]\n[Site "https://lichess.org/l6if35q7"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Ben_Dover"]\n[Black "cheesedout"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:09:49"]\n[WhiteElo "1853"]\n[BlackElo "1906"]\n[WhiteRatingDiff "+12"]\n[BlackRatingDiff "-15"]\n[ECO "B23"]\n[Opening "Sicilian Defense: Closed"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. e4 c5 2. Nc3 e6 3. f4 d5 4. Nf3 d4 5. Ne2 Nc6 6. c3 f6 7. cxd4 cxd4 8. d3 e5 9. Bd2 Bd7 10. Qb3 Qc7 11. fxe5 Nxe5 12. Rc1 Qb6 13. Qd5 Bc6 14. Qe6+ Ne7 15. Nexd4 Nxf3+ 16. gxf3 Qxd4 17. Bh3 Qe5 18. Rxc6 bxc6 19. Qd7+ Kf7 20. d4 Qxd4 21. Be6+ Kg6 22. Qxd4 Kh5 23. Bf7+ g6 24. Qxf6 1-0	Ben_Dover	cheesedout	1853	1906	Rated Bullet game	https://lichess.org/l6if35q7	2013-01-01 00:00:00	1-0	l6if35q7	2026-02-28 12:13:16.244
ad8bfb05-2345-49bc-958c-25d7871f99ab	[Event "Rated Classical game"]\n[Site "https://lichess.org/j7i999zt"]\n[Date "????.??.??"]\n[Round "?"]\n[White "luuletaja"]\n[Black "spaces"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:10:52"]\n[WhiteElo "1332"]\n[BlackElo "1506"]\n[WhiteRatingDiff "-10"]\n[BlackRatingDiff "+7"]\n[ECO "C00"]\n[Opening "French Defense: Steinitz Attack"]\n[TimeControl "300+8"]\n[Termination "Normal"]\n\n1. e4 e6 2. e5 c5 3. f4 d5 4. d4 cxd4 5. Qxd4 Nc6 6. Qd3 Bc5 7. c4 d4 8. Ne2 Nh6 9. Bd2 Qb6 10. b3 Nf5 11. g4 Ne3 12. Bxe3 dxe3 13. Bg2 Bb4+ 14. Kf1 Bd7 15. Nbc3 Bxc3 16. Nxc3 Nb4 17. Qd6 Qd8 18. Qxb4 Qh4 19. Ke2 Qf2+ 20. Kd3 Qd2+ 21. Ke4 Bc6+ 22. Nd5 exd5+ 23. Kf5 Bd7+ 24. e6 Bxe6+ 25. Ke5 Qb2+ 26. Kd6 Rd8+ 27. Kc5 b6+ 28. Kc6 Bd7+ 29. Kd6 Qf6+ 30. Kc7 Qc6# 0-1	luuletaja	spaces	1332	1506	Rated Classical game	https://lichess.org/j7i999zt	2013-01-01 00:00:00	0-1	j7i999zt	2026-02-28 12:13:25.334
7afcf866-b227-4952-88f8-76cd4503d863	[Event "Rated Bullet game"]\n[Site "https://lichess.org/zprhtrgh"]\n[Date "????.??.??"]\n[Round "?"]\n[White "cheesedout"]\n[Black "Ben_Dover"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:21:25"]\n[WhiteElo "1899"]\n[BlackElo "1858"]\n[WhiteRatingDiff "-14"]\n[BlackRatingDiff "+12"]\n[ECO "E20"]\n[Opening "Nimzo-Indian Defense #2"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. d4 Nf6 2. c4 e6 3. Nc3 c5 4. Nf3 cxd4 5. Nxd4 Bc5 6. Nf3 O-O 7. Bg5 h6 8. Bh4 d6 9. Bg3 Nbd7 10. e3 Qb6 11. Qc2 d5 12. cxd5 exd5 13. Be2 Bb4 14. O-O Nc5 15. Rab1 Nce4 16. Ne5 Nxg3 17. hxg3 Qd6 18. f4 d4 19. Nb5 Qd8 20. Nxd4 Nd5 21. Qd3 Bc5 22. Qe4 f5 23. Qf3 Bxd4 24. exd4 Nb4 25. Bc4+ Kh8 26. Ng6+ Kh7 27. Nxf8+ Qxf8 28. Rfe1 a6 29. a3 Nc6 30. Bd3 Nxd4 31. Qh5 Qc5 32. Re5 Nf3+ 33. Kf1 Nxe5 34. fxe5 Qxe5 35. Bxf5+ Bxf5 36. Qe2 Qxe2+ 37. Kxe2 Bxb1 38. Kd2 Bc2 39. g4 Bb3 40. g5 b5 41. g6+ Kxg6 42. Kc3 Kf6 43. Kb4 a5+ 44. Kxb3 a4+ 45. Kc3 Rb8 46. Kb4 Rc8 47. g3 Rc4+ 48. Kxb5 Rg4 49. Ka5 Rxg3 50. Kxa4 Rb3 51. Kxb3 h5 52. a4 h4 53. a5 h3 54. a6 h2 55. a7 h1=Q 56. a8=Q Qxa8 0-1	cheesedout	Ben_Dover	1899	1858	Rated Bullet game	https://lichess.org/zprhtrgh	2013-01-01 00:00:00	0-1	zprhtrgh	2026-02-28 12:14:56.961
14fa6047-d52c-4474-b710-217399cb8618	[Event "Rated Bullet game"]\n[Site "https://lichess.org/8trri7pj"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Ben_Dover"]\n[Black "cheesedout"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:24:17"]\n[WhiteElo "1870"]\n[BlackElo "1885"]\n[WhiteRatingDiff "+11"]\n[BlackRatingDiff "-12"]\n[ECO "B40"]\n[Opening "Sicilian Defense: Marshall Counterattack"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. e4 c5 2. d4 e6 3. Nf3 d5 4. exd5 exd5 5. Bb5+ Nc6 6. O-O Nf6 7. Re1+ Be7 8. Bf4 O-O 9. Nc3 a6 10. Bd3 c4 11. Be2 Bg4 12. h3 Bh5 13. g4 Bg6 14. Ne5 Nxe5 15. dxe5 Nd7 16. Nxd5 Bc5 17. Bxc4 b5 18. Bb3 h5 19. e6 fxe6 20. Nc7 Rxf4 21. Nxa8 Bxf2+ 22. Kg2 Bxe1 23. Bxe6+ Kh8 24. Qxe1 Qxa8+ 25. Kg3 Qf3+ 26. Kh4 hxg4 27. Bxg4 Qd5 28. Qe3 Rf6 29. Rd1 1-0	Ben_Dover	cheesedout	1870	1885	Rated Bullet game	https://lichess.org/8trri7pj	2013-01-01 00:00:00	1-0	8trri7pj	2026-02-28 12:15:11.751
5cf8c091-9a4a-41a6-a9f7-1fdcbd67cf26	[Event "Rated Classical game"]\n[Site "https://lichess.org/szypyxy7"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Pozitiv"]\n[Black "RaptureInVenice"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:22:18"]\n[WhiteElo "1415"]\n[BlackElo "1738"]\n[WhiteRatingDiff "-3"]\n[BlackRatingDiff "+5"]\n[ECO "B20"]\n[Opening "Sicilian Defense: Bowdler Attack"]\n[TimeControl "840+14"]\n[Termination "Normal"]\n\n1. e4 c5 2. Bc4 e6 3. e5 d5 4. Bb5+ Bd7 5. Bxd7+ Nxd7 6. Nf3 Nh6 7. d4 Nf5 8. O-O Rc8 9. Bg5 f6 10. exf6 Nxf6 11. Bxf6 Qxf6 12. c3 Bd6 13. Qa4+ Ke7 14. Qxa7 Rhf8 15. Re1 Kf7 16. Ne5+ Bxe5 17. dxe5 Qh4 18. Qxb7+ Kg8 19. Qb6 Ne3 20. Rxe3 Qxf2+ 0-1	Pozitiv	RaptureInVenice	1415	1738	Rated Classical game	https://lichess.org/szypyxy7	2013-01-01 00:00:00	0-1	szypyxy7	2026-02-28 12:16:19.427
bf4c4df6-c123-4495-adb2-8d7fda30313b	[Event "Rated Blitz game"]\n[Site "https://lichess.org/jbuzruvj"]\n[Date "????.??.??"]\n[Round "?"]\n[White "migsan"]\n[Black "yehshua"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:33:13"]\n[WhiteElo "1194"]\n[BlackElo "1548"]\n[WhiteRatingDiff "-3"]\n[BlackRatingDiff "+3"]\n[ECO "A00"]\n[Opening "Van't Kruijs Opening"]\n[TimeControl "420+0"]\n[Termination "Normal"]\n\n1. e3 e5 2. g3 Nc6 3. b3 Bc5 4. Bb2 d5 5. a3 Be6 6. f4 exf4 7. gxf4 Nf6 8. Nf3 Ne4 9. Ng5 Nxg5 10. fxg5 Qxg5 11. Qf3 Qh4+ 12. Qf2 Qxf2+ 13. Kxf2 d4 14. exd4 Bxd4+ 15. Ke2 Bxb2 16. Rg1 Bxa1 17. Rxg7 Nd4+ 18. Ke3 O-O-O 19. Rg5 Nxc2+ 20. Ke2 Nd4+ 21. Kd3 Nf3+ 22. Ke4 Nxg5+ 23. Kf4 h6 24. Kg3 Rhg8 25. Kh4 Ne4 26. Kh5 Bg4+ 27. Kxh6 Rd6+ 28. Kh7 Rdg6 29. Bg2 Ng5# 0-1	migsan	yehshua	1194	1548	Rated Blitz game	https://lichess.org/jbuzruvj	2013-01-01 00:00:00	0-1	jbuzruvj	2026-02-28 12:16:33.968
59f4bf4e-7e0b-4e8a-bdb2-a73d5148ddbc	[Event "Rated Blitz game"]\n[Site "https://lichess.org/1t2kxec5"]\n[Date "????.??.??"]\n[Round "?"]\n[White "tiggran"]\n[Black "blizz"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:36:36"]\n[WhiteElo "1564"]\n[BlackElo "1441"]\n[WhiteRatingDiff "+7"]\n[BlackRatingDiff "-32"]\n[ECO "B34"]\n[Opening "Sicilian Defense: Accelerated Dragon, Modern Variation"]\n[TimeControl "240+0"]\n[Termination "Normal"]\n\n1. e4 c5 2. Nf3 Nc6 3. d4 cxd4 4. Nxd4 g6 5. Nc3 Bg7 6. Be3 e6 7. f3 Nge7 8. Be2 d5 9. exd5 Nxd5 10. Nxd5 Qxd5 11. Qd2 Nxd4 12. O-O-O Nxe2+ 13. Qxe2 Qxa2 14. Qb5+ Ke7 15. Bc5+ Kf6 16. Bd4+ Ke7 17. Qb4+ Ke8 18. Bxg7 Rg8 19. Bf6 a6 20. Qe7# 1-0	tiggran	blizz	1564	1441	Rated Blitz game	https://lichess.org/1t2kxec5	2013-01-01 00:00:00	1-0	1t2kxec5	2026-02-28 12:18:26.312
0e3fbeff-0145-4769-ae76-6fed22731f67	[Event "Rated Blitz game"]\n[Site "https://lichess.org/aab3psbp"]\n[Date "????.??.??"]\n[Round "?"]\n[White "vegeta"]\n[Black "Maklaud695"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:49:51"]\n[WhiteElo "1724"]\n[BlackElo "1800"]\n[WhiteRatingDiff "+14"]\n[BlackRatingDiff "-13"]\n[ECO "C40"]\n[Opening "Latvian Gambit Accepted"]\n[TimeControl "300+0"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 f5 3. exf5 e4 4. Nd4 Nf6 5. Nc3 c5 6. Nb3 d5 7. d4 c4 8. Nd2 Nc6 9. Be2 Nxd4 10. O-O Bxf5 11. Bh5+ Nxh5 12. Qxh5+ g6 13. Qd1 Bd6 14. Nb3 Nxb3 15. axb3 Be5 16. Qxd5 Qc7 17. bxc4 Bxh2+ 18. Kh1 Rd8 19. Qb5+ Bd7 20. Qg5 Be5 21. Nxe4 Qxc4 22. Qxe5+ Kf7 23. Nd6+ 1-0	vegeta	Maklaud695	1724	1800	Rated Blitz game	https://lichess.org/aab3psbp	2013-01-01 00:00:00	1-0	aab3psbp	2026-02-28 12:18:33.291
57ff4a5a-39fe-477e-8617-1f120f6c31c3	[Event "Rated Blitz game"]\n[Site "https://lichess.org/tknxpk5u"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Link"]\n[Black "ilovemyself"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:50:35"]\n[WhiteElo "1361"]\n[BlackElo "1417"]\n[WhiteRatingDiff "-10"]\n[BlackRatingDiff "+12"]\n[ECO "B01"]\n[Opening "Scandinavian Defense: Modern Variation #2"]\n[TimeControl "300+0"]\n[Termination "Normal"]\n\n1. e4 d5 2. exd5 Nf6 3. Nc3 e6 4. Bc4 Bb4 5. Qf3 Nbd7 6. b3 Nc5 7. Bb2 Bxc3 8. Bxc3 O-O 9. dxe6 Bxe6 10. Bxe6 Re8 11. Ne2 Rxe6 12. O-O Qe7 13. Nf4 Rc6 14. Bxf6 Qxf6 15. Rfe1 Nd7 16. Re2 Qxa1+ 17. Re1 Qxe1# 0-1	Link	ilovemyself	1361	1417	Rated Blitz game	https://lichess.org/tknxpk5u	2013-01-01 00:00:00	0-1	tknxpk5u	2026-02-28 12:18:42.647
6429a9fd-776b-4979-9901-75c876bdda4c	[Event "Rated Classical game"]\n[Site "https://lichess.org/dht2wmpj"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Kingjones30"]\n[Black "khan"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "03:53:50"]\n[WhiteElo "1456"]\n[BlackElo "1438"]\n[WhiteRatingDiff "+11"]\n[BlackRatingDiff "-11"]\n[ECO "D01"]\n[Opening "Queen's Pawn Game: Chigorin Variation"]\n[TimeControl "300+8"]\n[Termination "Time forfeit"]\n\n1. d4 d5 2. Nc3 Nf6 3. h3 e6 4. Nf3 Bb4 5. Bd2 Ne4 6. a3 Bxc3 7. Bxc3 O-O 8. Ne5 Nc6 9. f3 Nxc3 10. bxc3 Nxe5 11. dxe5 c5 12. f4 Qh4+ 13. Kd2 Qxf4+ 14. e3 Qxe5 15. Bd3 c4 16. Be2 Qg3 17. Bf3 b5 18. h4 a6 19. Qf1 a5 20. Rh3 Qd6 21. h5 e5 22. h6 Bxh3 23. gxh3 g6 24. Qg2 e4 25. Bh5 Qe5 26. Bxg6 fxg6 27. Rf1 Rxf1 28. Qxf1 Qh2+ 29. Kc1 Qxh3 30. Qf6 Qxh6 31. Qe6+ Kh8 32. Qxd5 Rf8 33. Qxb5 Qxe3+ 34. Kb2 Qf4 35. Qxc4 Rb8+ 36. Ka2 Qf7 37. Qxf7 1-0	Kingjones30	khan	1456	1438	Rated Classical game	https://lichess.org/dht2wmpj	2013-01-01 00:00:00	1-0	dht2wmpj	2026-02-28 12:19:39.341
dc3e6f08-d9a4-4d26-b36a-4b836db6d7d8	[Event "Rated Classical game"]\n[Site "https://lichess.org/il5y6nwa"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Alexey_K"]\n[Black "gregosaurus"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "04:06:20"]\n[WhiteElo "1477"]\n[BlackElo "1081"]\n[WhiteRatingDiff "+2"]\n[BlackRatingDiff "-5"]\n[ECO "B02"]\n[Opening "Alekhine Defense"]\n[TimeControl "900+9"]\n[Termination "Normal"]\n\n1. e4 Nf6 2. Nc3 Nc6 3. d3 e5 4. Be3 Bb4 5. Qd2 Ng4 6. a3 Ba5 7. b4 Bb6 8. Bxb6 cxb6 9. b5 Nd4 10. O-O-O d5 11. f3 Nf6 12. Qg5 Qc7 13. Qxg7 Rf8 14. Qxf6 Qxc3 15. Qxe5+ Be6 16. Rd2 Qxa3+ 17. Kd1 Qc3 18. exd5 O-O-O 19. dxe6 fxe6 20. Ne2 Rf5 21. Qxd4 Rxd4 22. Nxc3 Rb4 23. Re2 a5 24. Rxe6 a4 25. g4 Rc5 26. Kd2 a3 27. Bh3 Rb2 28. g5 a2 29. Re8+ Kc7 30. Ra1 Rxg5 31. Nxa2 Rgxb5 32. Nc3 Rb1 33. Rxb1 1-0	Alexey_K	gregosaurus	1477	1081	Rated Classical game	https://lichess.org/il5y6nwa	2013-01-01 00:00:00	1-0	il5y6nwa	2026-02-28 12:22:12.914
4d258286-b5a9-449d-9ee5-3fed63b1e682	[Event "Rated Classical game"]\n[Site "https://lichess.org/wujruyjz"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Milligan"]\n[Black "samijoon"]\n[Result "1/2-1/2"]\n[UTCDate "2013.01.01"]\n[UTCTime "04:15:48"]\n[WhiteElo "1416"]\n[BlackElo "1407"]\n[WhiteRatingDiff "-1"]\n[BlackRatingDiff "+0"]\n[ECO "C41"]\n[Opening "Philidor Defense #2"]\n[TimeControl "900+0"]\n[Termination "Time forfeit"]\n\n1. e4 e5 2. Nf3 d6 3. Nc3 Nf6 4. d4 exd4 5. Nxd4 d5 6. e5 Ne4 7. Nxe4 dxe4 8. Bc4 Bc5 9. c3 Nc6 10. Be3 h5 11. a3 O-O 12. O-O Qe7 13. b4 Bxd4 14. cxd4 Be6 15. Rc1 Bxc4 16. Rxc4 Rad8 17. Qxh5 g6 18. Qe2 Kg7 19. b5 Na5 20. Rb4 b6 21. Qd2 Rh8 22. d5 Nb7 23. Bg5 Qxe5 24. Bxd8 Rxd8 25. Qe3 Rxd5 26. Re1 Qd6 27. Rxe4 Rd1 28. h3 Rd3 29. Qg5 Rxa3 30. R1e3 Ra1+ 31. Re1 Ra5 32. g3 Nc5 33. Qc1 Nxe4 34. Rxe4 Rxb5 35. Qc3+ Qf6 36. Qxc7 Rb1+ 37. Kg2 a5 38. Re7 Rb2 39. h4 Qxf2+ 40. Kh3 Qh2+ 41. Kg4 Rb4+ 42. Kf3 Qh1+ 43. Ke3 Rb3+ 44. Kd4 Qd1+ 45. Kc4 Qc2+ 46. Kd5 Rd3+ 47. Ke5 Re3+ 48. Kd6 Qd3+ 49. Kc6 Qc4+ 50. Kxb6 Qxc7+ 51. Rxc7 a4 52. g4 a3 53. Rc1 a2 54. Ra1 Re2 55. Kc5 Rb2 56. Kc4 Kf6 57. Kc3 Rf2 58. Kd3 Rg2 59. g5+ Ke5 60. Kc3 Kf4 61. Kb3 Kg4 62. Rxa2 Rxa2 63. Kxa2 Kxh4 64. Kb2 Kxg5 65. Kc2 f6 66. Kd3 f5 67. Ke3 Kg4 68. Kf2 g5 69. Ke3 f4+ 70. Ke4 Kh4 71. Kf3 Kh5 72. Kf2 g4 73. Kg2 f3+ 74. Kg3 Kg5 75. Kf2 Kf4 76. Kf1 g3 77. Kg1 Ke3 78. Kf1 g2+ 79. Kg1 Ke2 80. Kh2 f2 81. Kxg2 f1=Q+ 82. Kg3 Qf3+ 83. Kh4 Qg2 84. Kh5 Kf3 85. Kh6 Kg4 86. Kg6 Qf3 87. Kg7 Kf5 88. Kf7 Qe4 89. Kg7 Kg5 90. Kf7 Qe5 91. Kg8 Qf6 92. Kh7 1/2-1/2	Milligan	samijoon	1416	1407	Rated Classical game	https://lichess.org/wujruyjz	2013-01-01 00:00:00	1/2-1/2	wujruyjz	2026-02-28 12:22:55.373
1e278a6f-daff-4b0a-9e72-3c2583401da7	[Event "Rated Blitz game"]\n[Site "https://lichess.org/2nsrcq3t"]\n[Date "????.??.??"]\n[Round "?"]\n[White "xadrez80"]\n[Black "Atomicangel"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "04:19:11"]\n[WhiteElo "1906"]\n[BlackElo "1973"]\n[WhiteRatingDiff "-23"]\n[BlackRatingDiff "+8"]\n[ECO "D02"]\n[Opening "Queen's Pawn Game: Chigorin Variation"]\n[TimeControl "180+0"]\n[Termination "Time forfeit"]\n\n1. d4 d5 2. Nf3 Nc6 3. Bf4 Bg4 4. e3 f6 5. Be2 Bxf3 6. Bxf3 e5 7. dxe5 fxe5 8. Bg3 Nf6 9. Bh4 e4 10. Bh5+ g6 11. Bg4 Ne5 12. Be2 c6 13. Nc3 Bd6 14. Bg3 O-O 15. O-O Qe7 16. a3 Rad8 17. Qc1 Neg4 18. Bxd6 Qxd6 19. Bxg4 Nxg4 20. g3 Ne5 21. Ne2 Nf3+ 22. Kg2 g5 23. h3 h5 24. Ng1 Rd7 25. Rd1 Rdf7 26. Nxf3 Rxf3 27. Rd2 Qf6 28. Qe1 h4 29. g4 Qe5 30. c3 R3f7 31. Rad1 Qf6 32. Qe2 Qe5 33. Rf1 Rf3 34. Qd1 Rg3+ 35. fxg3 Qxg3+ 36. Kh1 Qxh3+ 37. Kg1 Qxe3+ 38. Rdf2 Qg3+ 39. Rg2 Qe3+ 40. Rff2 h3 0-1	xadrez80	Atomicangel	1906	1973	Rated Blitz game	https://lichess.org/2nsrcq3t	2013-01-01 00:00:00	0-1	2nsrcq3t	2026-02-28 12:23:10.815
b80c9220-beed-4f36-b29b-46f8c85831c6	[Event "Rated Bullet game"]\n[Site "https://lichess.org/42nj22km"]\n[Date "????.??.??"]\n[Round "?"]\n[White "cheesedout"]\n[Black "xiaoqiao"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "04:20:34"]\n[WhiteElo "1818"]\n[BlackElo "2073"]\n[WhiteRatingDiff "-5"]\n[BlackRatingDiff "+5"]\n[ECO "A43"]\n[Opening "Old Benoni Defense"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. d4 c5 2. c4 cxd4 3. Qxd4 Nc6 4. Qd1 Nf6 5. Nc3 e5 6. a3 Bc5 7. e4 d6 8. Nf3 Ng4 9. Be3 Bxe3 10. fxe3 Nxe3 11. Qe2 Ng4 12. O-O-O O-O 13. h3 Nf6 14. g4 Be6 15. g5 Ne8 16. Nd5 Rc8 17. Kb1 Na5 18. Rc1 a6 19. h4 b5 20. cxb5 axb5 21. Rxc8 Qxc8 22. h5 Nc4 23. g6 f6 24. gxh7+ Kh8 25. h6 g6 26. Qg2 Kxh7 27. Rg1 Qd7 28. Qxg6+ Kh8 29. Nxf6 Nxf6 30. h7 Qxh7 31. Qg3 Rg8 0-1	cheesedout	xiaoqiao	1818	2073	Rated Bullet game	https://lichess.org/42nj22km	2013-01-01 00:00:00	0-1	42nj22km	2026-02-28 12:23:45.685
b212ac28-05e3-4c15-acd2-6c26c8f80a28	[Event "Rated Blitz game"]\n[Site "https://lichess.org/cbvquwtp"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Ghost_Lombardi"]\n[Black "Atomicangel"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "04:32:41"]\n[WhiteElo "2125"]\n[BlackElo "1974"]\n[WhiteRatingDiff "+10"]\n[BlackRatingDiff "-6"]\n[ECO "A04"]\n[Opening "Zukertort Opening: Black Mustang Defense"]\n[TimeControl "180+0"]\n[Termination "Normal"]\n\n1. Nf3 Nc6 2. d3 e5 3. g3 d5 4. Bg2 Nf6 5. O-O Bd6 6. Nbd2 O-O 7. e4 Bg4 8. h3 Bh5 9. g4 Nxg4 10. hxg4 Bxg4 11. exd5 Nd4 12. c3 Nxf3+ 13. Bxf3 Bh3 14. Re1 Qg5+ 15. Kh1 Qh4 16. Re4 Qxf2 17. Qe2 Qg3 18. Nf1 Bxf1 19. Qxf1 f5 20. Re2 Rf6 21. Rg2 Rh6+ 22. Kg1 Qh4 23. Bxh6 1-0	Ghost_Lombardi	Atomicangel	2125	1974	Rated Blitz game	https://lichess.org/cbvquwtp	2013-01-01 00:00:00	1-0	cbvquwtp	2026-02-28 12:26:22.46
fca149f0-baab-416e-809a-2446f79b458d	[Event "Rated Classical game"]\n[Site "https://lichess.org/5dgx13r3"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Pozitiv"]\n[Black "robusto"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "04:37:48"]\n[WhiteElo "1409"]\n[BlackElo "1755"]\n[WhiteRatingDiff "-3"]\n[BlackRatingDiff "+4"]\n[ECO "B01"]\n[Opening "Scandinavian Defense"]\n[TimeControl "840+14"]\n[Termination "Normal"]\n\n1. e4 d5 2. e5 d4 3. Bc4 Nc6 4. Qe2 Nh6 5. e6 Bxe6 6. Bxe6 fxe6 7. Qxe6 Qd6 8. Qxd6 exd6 9. Nf3 Be7 10. O-O O-O 11. d3 Nf5 12. Re1 Bf6 13. Bg5 Ne5 14. Bxf6 Rxf6 15. Nxe5 dxe5 16. Rxe5 Nd6 17. Re7 Raf8 18. f3 Rc8 19. Rd7 Re6 20. Nd2 Re2 21. Rd1 Nf5 22. Kf1 Ree8 23. Re1 Ne3+ 24. Kf2 Ng4+ 25. fxg4 Kf8 26. Rxd4 c5 27. Rd7 Rc6 28. Rxb7 Rce6 29. Ne4 a6 30. Rf1 Kg8 31. Kg1 h6 32. Nxc5 Re2 33. c3 Rc2 34. Nxa6 Ree2 35. Rb8+ Kh7 36. Re8 Rxg2+ 37. Kh1 Rxh2+ 0-1	Pozitiv	robusto	1409	1755	Rated Classical game	https://lichess.org/5dgx13r3	2013-01-01 00:00:00	0-1	5dgx13r3	2026-02-28 12:27:01.254
30c4c6c9-6f5c-449c-9d68-e7551d484c5f	[Event "Rated Bullet game"]\n[Site "https://lichess.org/13e4v9dw"]\n[Date "????.??.??"]\n[Round "?"]\n[White "ptdhina"]\n[Black "_viper_"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "04:57:21"]\n[WhiteElo "1565"]\n[BlackElo "1598"]\n[WhiteRatingDiff "-11"]\n[BlackRatingDiff "+14"]\n[ECO "C50"]\n[Opening "Italian Game: Giuoco Pianissimo, Normal"]\n[TimeControl "60+2"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. d3 Nf6 5. O-O d6 6. c3 Bg4 7. a4 a6 8. b4 Ba7 9. h3 Bh5 10. g4 Nxg4 11. hxg4 Bxg4 12. Be3 Qf6 13. Bxa7 Bxf3 14. Kh2 Qh4+ 15. Kg1 0-1	ptdhina	_viper_	1565	1598	Rated Bullet game	https://lichess.org/13e4v9dw	2013-01-01 00:00:00	0-1	13e4v9dw	2026-02-28 12:28:45.166
dfa67699-ec3a-42e4-85ed-3f8590bc8185	[Event "Rated Bullet game"]\n[Site "https://lichess.org/8jb5kiqw"]\n[Date "????.??.??"]\n[Round "?"]\n[White "_viper_"]\n[Black "ptdhina"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "05:13:09"]\n[WhiteElo "1580"]\n[BlackElo "1578"]\n[WhiteRatingDiff "+14"]\n[BlackRatingDiff "-11"]\n[ECO "C53"]\n[Opening "Italian Game: Classical Variation, La Bourdonnais Variation"]\n[TimeControl "60+2"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. c3 d6 5. d4 exd4 6. cxd4 Bb6 7. d5 Na5 8. Bb5+ c6 9. dxc6 Nxc6 10. Nd4 Bd7 11. Nxc6 bxc6 12. Bc4 Qf6 13. O-O Nh6 14. Nc3 Ng4 15. Qe2 O-O 16. Be3 Rfe8 17. Bxb6 axb6 18. f3 Ne5 19. Bb3 d5 20. exd5 Ng4 21. Qf2 Ne3 22. Rfe1 Qd4 23. dxc6 Bxc6 24. Rac1 Nf5 25. Ne2 Qd2 26. Rxc6 Ne3 27. Rc7 Nf5 28. Bxf7+ Kh8 29. Bxe8 Rxe8 30. Rcc1 Nd6 31. Ng3 Rxe1+ 32. Rxe1 Qxb2 33. Qxb2 h6 34. Qxb6 Nf7 35. a4 Ne5 36. a5 Nd3 37. Rd1 Ne1 38. Rxe1 1-0	_viper_	ptdhina	1580	1578	Rated Bullet game	https://lichess.org/8jb5kiqw	2013-01-01 00:00:00	1-0	8jb5kiqw	2026-02-28 12:30:03.767
cb7da421-7fe7-41e5-a40d-a87bf2b85f26	[Event "Rated Blitz game"]\n[Site "https://lichess.org/a0c1jnhy"]\n[Date "????.??.??"]\n[Round "?"]\n[White "arun"]\n[Black "jorespi"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "05:22:55"]\n[WhiteElo "1068"]\n[BlackElo "1587"]\n[WhiteRatingDiff "+64"]\n[BlackRatingDiff "-21"]\n[ECO "C22"]\n[Opening "Center Game: Normal Variation"]\n[TimeControl "300+4"]\n[Termination "Normal"]\n\n1. e4 e5 2. d4 exd4 3. Qxd4 Nc6 4. Qd1 d6 5. Bb5 Bd7 6. e5 Nxe5 7. Bxd7+ Qxd7 8. Nc3 Nf6 9. Nf3 Nxf3+ 10. Qxf3 c6 11. O-O Be7 12. Re1 O-O 13. Qg3 Kh8 14. Bg5 Rfe8 15. Bxf6 Bxf6 16. Rxe8+ Rxe8 17. a4 d5 18. h3 d4 19. Rd1 Qe6 20. Nb1 Qe1+ 21. Rxe1 Rxe1+ 22. Kh2 g6 23. Nd2 Be5 24. f4 Bxf4 25. Qxf4 1-0	arun	jorespi	1068	1587	Rated Blitz game	https://lichess.org/a0c1jnhy	2013-01-01 00:00:00	1-0	a0c1jnhy	2026-02-28 12:31:57.202
0418ff97-9611-462d-8fef-43936f283ad9	[Event "Rated Classical game"]\n[Site "https://lichess.org/2oawjcsu"]\n[Date "????.??.??"]\n[Round "?"]\n[White "4lawsdotcom"]\n[Black "khan"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "05:28:45"]\n[WhiteElo "1604"]\n[BlackElo "1405"]\n[WhiteRatingDiff "-36"]\n[BlackRatingDiff "+17"]\n[ECO "C55"]\n[Opening "Italian Game: Anti-Fried Liver Defense"]\n[TimeControl "480+4"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 Nc6 3. Bc4 h6 4. O-O d6 5. c3 Qe7 6. d4 Be6 7. d5 Nf6 8. dxe6 fxe6 9. Na3 Nxe4 10. Re1 Nc5 11. Nb5 a6 12. Nxe5 axb5 13. Nxc6 bxc6 14. Qh5+ Kd7 15. Bg5 hxg5 16. Bxe6+ Nxe6 17. Qxh8 g6 18. Qh3 Re8 19. Re3 Bg7 20. Rae1 Be5 21. g3 Qf7 22. Rd1 Qf5 23. Qg4 Qxg4 24. Rdd3 Nc5 25. f3 Qh3 26. Rd2 g4 27. fxg4 Qxg4 28. b4 Na6 29. a3 Bf4 30. Rxe8 Kxe8 31. Rd4 g5 32. Kf2 Be3+ 33. Kxe3 Qxd4+ 34. cxd4 c5 35. dxc5 dxc5 36. bxc5 Nxc5 37. Kd4 Nb7 38. Kd5 Kd7 39. h3 c5 40. Ke4 c4 41. Kd4 Kd6 42. h4 gxh4 43. gxh4 Nd8 44. h5 Nf7 45. Kc3 Kc5 46. Kc2 Kd4 47. Kd2 c3+ 48. Kc2 Kc4 49. Kc1 Kb3 50. Kb1 Kxa3 51. Kc2 b4 52. Kb1 Kb3 53. h6 Nxh6 54. Ka1 Kc4 55. Kb1 b3 56. Ka1 Nf5 57. Kb1 Nd4 58. Ka1 c2 59. Kb2 Kd3 60. Kc1 Kc4 61. Kb2 Ne2 62. Ka1 c1=Q# 0-1	4lawsdotcom	khan	1604	1405	Rated Classical game	https://lichess.org/2oawjcsu	2013-01-01 00:00:00	0-1	2oawjcsu	2026-02-28 12:33:40.014
7d5917c1-b721-4edf-8667-30bc46c0b5e7	[Event "Rated Classical game"]\n[Site "https://lichess.org/z0ule4l2"]\n[Date "????.??.??"]\n[Round "?"]\n[White "veter1611"]\n[Black "famcaliap"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "05:42:58"]\n[WhiteElo "1914"]\n[BlackElo "1704"]\n[WhiteRatingDiff "-18"]\n[BlackRatingDiff "+16"]\n[ECO "C60"]\n[Opening "Ruy Lopez"]\n[TimeControl "540+5"]\n[Termination "Time forfeit"]\n\n1. e4 e5 2. Nf3 Nc6 3. Bb5 Bd6 4. Bxc6 dxc6 5. h3 Nf6 6. d3 h6 7. O-O O-O 8. Nbd2 Qe7 9. Nc4 b6 10. Be3 Ba6 11. Ncd2 c5 12. Nh4 Bc8 13. f4 Nh7 14. Qe1 exf4 15. Bxf4 Bxf4 16. Rxf4 Ng5 17. Qg3 Be6 18. Raf1 a5 19. Ndf3 Rad8 20. Ne5 Qd6 21. Nef3 Qe7 22. Nf5 Nxf3+ 23. R1xf3 Bxf5 24. Rxf5 Qe6 25. Rh5 Kh7 26. Qxc7 Rd7 27. Qe5 Qxe5 28. Rxe5 Rd6 29. Ref5 f6 30. Kf2 Re6 31. Rd5 Rf7 32. Rd8 Re5 33. Rd6 f5 34. Rxb6 g6 35. Ra6 Rb7 36. b3 fxe4 37. dxe4 Rxe4 38. Rxa5 Rd7 39. Rxc5 Rd2+ 40. Kg3 h5 41. Rc7+ Kh6 42. Rc6 Ree2 43. a4 Rxg2+ 44. Kf4 Rge2 45. a5 Rd4+ 0-1	veter1611	famcaliap	1914	1704	Rated Classical game	https://lichess.org/z0ule4l2	2013-01-01 00:00:00	0-1	z0ule4l2	2026-02-28 12:36:39.424
c13fd9d4-8e09-4440-aebc-e989ee38564e	[Event "Rated Blitz game"]\n[Site "https://lichess.org/fo8jpn6i"]\n[Date "????.??.??"]\n[Round "?"]\n[White "driverblag"]\n[Black "bjagus"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "05:49:24"]\n[WhiteElo "1486"]\n[BlackElo "1742"]\n[WhiteRatingDiff "-4"]\n[BlackRatingDiff "+5"]\n[ECO "C00"]\n[Opening "French Defense: Queen's Knight"]\n[TimeControl "360+2"]\n[Termination "Normal"]\n\n1. e4 e6 2. Nc3 d5 3. exd5 exd5 4. Qe2+ Be6 5. Qb5+ Nd7 6. Qxb7 Ngf6 7. Bb5 Bc5 8. Bxd7+ Nxd7 9. h3 O-O 10. Nxd5 Re8 11. Ne2 Bxd5 12. Qxd5 Qe7 13. Qd3 Ne5 14. Qe4 Qf6 15. O-O Ng6 16. Qc4 Bd6 17. Nc3 Qe5 18. g3 Rad8 19. d3 Qh5 20. Kh2 Ne5 21. Qd4 Nf3+ 22. Kg2 Nxd4 23. Be3 Qf3+ 24. Kg1 Bxg3 25. Bxd4 Rxd4 26. fxg3 Qxg3+ 27. Kh1 Qxh3+ 28. Kg1 Qg3+ 29. Kh1 Rh4# 0-1	driverblag	bjagus	1486	1742	Rated Blitz game	https://lichess.org/fo8jpn6i	2013-01-01 00:00:00	0-1	fo8jpn6i	2026-02-28 12:37:56.081
847a311e-1a14-44dc-9c1a-9635dd093726	[Event "Rated Bullet game"]\n[Site "https://lichess.org/8743nbcx"]\n[Date "????.??.??"]\n[Round "?"]\n[White "BulletKiller"]\n[Black "namesnik"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "06:00:32"]\n[WhiteElo "1500"]\n[BlackElo "1534"]\n[WhiteRatingDiff "-159"]\n[BlackRatingDiff "+8"]\n[ECO "A00"]\n[Opening "Gedult's Opening"]\n[TimeControl "0+1"]\n[Termination "Normal"]\n\n1. f3 d6 2. g3 e5 3. Bg2 Nc6 4. e3 Nf6 5. d3 d5 6. f4 exf4 7. exf4 Bd6 8. Qe2+ Qe7 9. Qxe7+ Bxe7 10. Nf3 O-O 11. O-O Re8 12. c3 d4 13. c4 Bc5 14. a3 Bb6 15. b4 a6 16. Bd2 Bg4 17. Nh4 h6 18. h3 Be6 19. g4 Rad8 20. f5 Bc8 21. Nf3 Ba7 22. c5 b6 23. cxb6 Bxb6 24. a4 a5 25. b5 Na7 26. Na3 Bb7 27. Nc4 Bxf3 28. Bxf3 Nc8 29. Bc6 Re7 30. Nxb6 cxb6 31. Bf4 Na7 32. Bf3 Rc8 33. Ra3 Rc2 34. Be4 Nxe4 35. dxe4 Rxe4 36. Bc7 Ree2 37. Bxb6 Rg2+ 38. Kh1 Rh2+ 39. Kg1 Rcg2# 0-1	BulletKiller	namesnik	1500	1534	Rated Bullet game	https://lichess.org/8743nbcx	2013-01-01 00:00:00	0-1	8743nbcx	2026-02-28 12:40:42.379
00f8af5c-940f-4254-a6f2-27e18a0a257b	[Event "Rated Bullet game"]\n[Site "https://lichess.org/qssz2qhb"]\n[Date "????.??.??"]\n[Round "?"]\n[White "nichiren1967"]\n[Black "cheesedout"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "06:01:12"]\n[WhiteElo "1693"]\n[BlackElo "1818"]\n[WhiteRatingDiff "-7"]\n[BlackRatingDiff "+8"]\n[ECO "B20"]\n[Opening "Sicilian Defense"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. e4 c5 2. e5 e6 3. f4 f6 4. Nf3 Nc6 5. c3 d6 6. d4 cxd4 7. cxd4 fxe5 8. fxe5 dxe5 9. Nxe5 Nxe5 10. dxe5 Qxd1+ 11. Kxd1 Ne7 12. Bb5+ Bd7 13. Bxd7+ Kxd7 14. Nc3 Nc6 15. Bf4 h6 16. Kc2 g5 17. Bg3 h5 18. h3 h4 19. Bh2 Bg7 20. Rhf1 Bxe5 21. Rf7+ Kd6 22. Bg1 Bd4 23. Rd1 Ke5 24. Rxb7 Bxg1 25. Rxg1 Nd4+ 26. Kb1 Rac8 27. Re1+ Kf5 28. Rxa7 Rb8 29. Ra5+ Kf4 30. Ra4 e5 31. Nd5+ Kf5 32. Ne3+ Kf4 33. Ng4 Kg3 34. Rxe5 Rbd8 35. Re4 Nc6 36. Re3+ Kxg2 37. Rc4 Nd4 38. Re4 Nf3 39. Rc2+ Rd2 40. Re2+ Rxe2 41. Rxe2+ Kg3 42. Rg2+ Kf4 43. Nf6 Re8 44. Nd5+ Kf5 45. Ne7+ Kf6 46. Rxg5 Rxe7 47. Rg6+ Kf7 48. Rg7+ Kxg7 0-1	nichiren1967	cheesedout	1693	1818	Rated Bullet game	https://lichess.org/qssz2qhb	2013-01-01 00:00:00	0-1	qssz2qhb	2026-02-28 12:40:56.655
688ed5fa-fc54-4bb4-8098-955a9f53bd88	[Event "Rated Classical game"]\n[Site "https://lichess.org/t31ek2u9"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Verminard"]\n[Black "4lawsdotcom"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "06:05:42"]\n[WhiteElo "1496"]\n[BlackElo "1538"]\n[WhiteRatingDiff "+117"]\n[BlackRatingDiff "-20"]\n[ECO "D00"]\n[Opening "Queen's Pawn Game #2"]\n[TimeControl "480+4"]\n[Termination "Normal"]\n\n1. d4 d5 2. e3 c5 3. c4 cxd4 4. Qxd4 Nc6 5. Qd2 Nf6 6. Nc3 e6 7. c5 Bxc5 8. Bb5 a6 9. Bxc6+ bxc6 10. Nf3 Qc7 11. Na4 Bd6 12. Nd4 e5 13. Nf5 Bxf5 14. Qc3 Rb8 15. O-O h5 16. f3 h4 17. e4 Be6 18. Bg5 h3 19. g3 Rh5 20. Bxf6 gxf6 21. Rac1 Bd7 22. exd5 e4 23. fxe4 Ke7 24. dxc6 Be6 25. Qxf6+ Ke8 26. Qc3 Rb4 27. Qf3 Rxa4 28. Qxh5 Bxg3 29. Qh8+ Ke7 30. Qc3 Bxh2+ 31. Kh1 Rxe4 32. Rf3 Bd5 33. Qc5+ Ke8 34. Qxd5 Re2 35. Rxh3 Bf4 36. Rh8+ Ke7 37. Qc5+ Bd6 38. Qg5+ Ke6 39. Qg4+ Ke7 40. Qxe2+ 1-0	Verminard	4lawsdotcom	1496	1538	Rated Classical game	https://lichess.org/t31ek2u9	2013-01-01 00:00:00	1-0	t31ek2u9	2026-02-28 12:42:09.331
c01dbb34-dd4a-4e89-84c0-b86c9d262ebe	[Event "Rated Blitz game"]\n[Site "https://lichess.org/jihrfrvc"]\n[Date "????.??.??"]\n[Round "?"]\n[White "_viper_"]\n[Black "arina1999"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "06:07:35"]\n[WhiteElo "1671"]\n[BlackElo "2132"]\n[WhiteRatingDiff "+27"]\n[BlackRatingDiff "-27"]\n[ECO "A03"]\n[Opening "Bird Opening: Dutch Variation"]\n[TimeControl "60+3"]\n[Termination "Normal"]\n\n1. f4 d5 2. e3 c5 3. Nf3 Nc6 4. Be2 Bg4 5. d3 Bxf3 6. Bxf3 e5 7. fxe5 Nxe5 8. O-O Nf6 9. Bd2 Bd6 10. Nc3 Nxf3+ 11. Rxf3 a6 12. Qe2 Qc7 13. g3 O-O-O 14. d4 c4 15. b3 cxb3 16. cxb3 h5 17. Nxd5 Nxd5 18. Rc1 Rd7 19. Rxc7+ Rxc7 20. e4 Nb4 21. Bxb4 Bxb4 22. Rf1 Kb8 23. e5 Rd8 24. Qxh5 Rxd4 25. Rxf7 Rc1+ 26. Rf1 Rc2 27. Qe8+ Ka7 28. Qf7 Bc5 29. Kh1 Rdd2 30. Qh5 Re2 31. e6 Rxe6 32. a4 Ree2 33. Qh3 g5 34. Qh5 g4 35. Rd1 Rf2 36. Re1 Bb4 37. Rd1 Bc5 38. Re1 Rfd2 39. Rf1 Bd6 40. Re1 Bb4 41. Rf1 Rb2 42. Qh4 Be7 43. Qh5 Bb4 44. Qh4 Rbc2 45. Qh5 Bc5 46. Qh4 Be3 47. b4 Re2 48. b5 axb5 49. axb5 Ra2 50. b6+ Bxb6 51. Rb1 Ka6 52. Qh5 Rec2 53. Qb5+ Ka7 54. Qxb6+ Kb8 55. Qxb7# 1-0	_viper_	arina1999	1671	2132	Rated Blitz game	https://lichess.org/jihrfrvc	2013-01-01 00:00:00	1-0	jihrfrvc	2026-02-28 12:42:34.63
ad1e3ee0-fae4-447c-aecb-05d905b30810	[Event "Rated Bullet game"]\n[Site "https://lichess.org/h3gjf0bb"]\n[Date "????.??.??"]\n[Round "?"]\n[White "nichiren1967"]\n[Black "cheesedout"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "06:18:53"]\n[WhiteElo "1655"]\n[BlackElo "1857"]\n[WhiteRatingDiff "-6"]\n[BlackRatingDiff "+6"]\n[ECO "B20"]\n[Opening "Sicilian Defense"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. e4 c5 2. e5 e6 3. f4 Nh6 4. Nf3 Nf5 5. Bc4 f6 6. d4 Nc6 7. d5 exd5 8. Bxd5 fxe5 9. fxe5 Ncd4 10. O-O d6 11. Nxd4 cxd4 12. Qh5+ g6 13. Qf3 dxe5 14. Be4 Qf6 15. g4 Qb6 16. gxf5 d3+ 17. Kg2 Bxf5 18. Bxf5 gxf5 19. Qxf5 Be7 20. Qf7+ Kd7 21. Nc3 Qc6+ 22. Qd5+ Qxd5+ 23. Nxd5 Rhg8+ 24. Kh1 Bc5 25. cxd3 Rg6 26. Bd2 Rag8 27. Bb4 Bd4 28. Bc3 Be3 29. d4 exd4 30. Be1 d3 31. Bg3 d2 32. Nxe3 Rxg3 33. hxg3 Re8 34. Kh2 Rxe3 35. Rf2 Re1 36. Rxd2+ Kc6 37. Rxe1 Kb6 38. Ree2 a6 39. Rf2 Ka7 40. Rf3 a5 41. Rf4 b6 0-1	nichiren1967	cheesedout	1655	1857	Rated Bullet game	https://lichess.org/h3gjf0bb	2013-01-01 00:00:00	0-1	h3gjf0bb	2026-02-28 12:45:12.748
cb6427e3-70ae-4bdb-ad3d-7df9ae5bfda7	[Event "Rated Blitz game"]\n[Site "https://lichess.org/26tae18h"]\n[Date "????.??.??"]\n[Round "?"]\n[White "psonio"]\n[Black "Atomicangel"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "06:27:16"]\n[WhiteElo "1888"]\n[BlackElo "1977"]\n[WhiteRatingDiff "-29"]\n[BlackRatingDiff "+8"]\n[ECO "C63"]\n[Opening "Ruy Lopez: Schliemann Defense, Exchange Variation"]\n[TimeControl "240+0"]\n[Termination "Normal"]\n\n1. e4 Nc6 2. Nf3 e5 3. Bb5 f5 4. Bxc6 dxc6 5. Nxe5 Nf6 6. d4 fxe4 7. O-O Bd6 8. Bg5 O-O 9. c3 Kh8 10. Qb3 Qe7 11. Nd2 Bxe5 12. dxe5 Qxe5 13. Bxf6 Rxf6 14. Rae1 Bf5 15. Qxb7 Re8 16. Re3 Rh6 17. g3 Bg6 18. Rfe1 Qf5 19. Qxc6 Qh3 20. Nxe4 Qxh2+ 21. Kf1 Qh1+ 22. Ke2 Bh5+ 23. Kd2 Qxe1+ 24. Rxe1 Rxc6 25. Ke3 Rce6 26. f3 c5 27. Kf4 h6 28. Rh1 g5+ 29. Ke3 Bxf3 30. Kxf3 Rxe4 31. Rxh6+ Kg7 32. Ra6 R8e7 33. Ra5 Kg6 34. Rxc5 Re3+ 35. Kg4 R7e4+ 36. Kh3 Kh5 37. Kg2 Kg4 38. a4 Re2+ 39. Kf1 Re1+ 40. Kf2 R4e2# 0-1	psonio	Atomicangel	1888	1977	Rated Blitz game	https://lichess.org/26tae18h	2013-01-01 00:00:00	0-1	26tae18h	2026-02-28 12:47:08.723
c4fccec2-8f49-4f92-bb8b-e3de5db22cb6	[Event "Rated Bullet game"]\n[Site "https://lichess.org/l0g5jkfe"]\n[Date "????.??.??"]\n[Round "?"]\n[White "nichiren1967"]\n[Black "cheesedout"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "06:28:50"]\n[WhiteElo "1645"]\n[BlackElo "1867"]\n[WhiteRatingDiff "+18"]\n[BlackRatingDiff "-18"]\n[ECO "B21"]\n[Opening "Sicilian Defense: McDonnell Attack"]\n[TimeControl "60+0"]\n[Termination "Time forfeit"]\n\n1. e4 c5 2. f4 e6 3. e5 Nc6 4. Nf3 f6 5. Bb5 fxe5 6. fxe5 Nge7 7. O-O Nd5 8. c4 Nf4 9. d3 Ng6 10. Bg5 Be7 11. Bxe7 Qxe7 12. Nc3 a6 13. Bxc6 bxc6 14. Ne4 O-O 15. Nd6 a5 16. Qd2 Rxf3 17. Rxf3 Nxe5 18. Nxc8 Rxc8 19. Re3 Ng6 20. Rae1 Nf4 21. Qxa5 Qg5 22. Rg3 Qf6 23. Qxc5 Nxd3 24. Rf1 Qxf1+ 25. Kxf1 Nxc5 26. Ke2 Ne4 27. Re3 Nf6 28. g3 Rb8 29. b3 Rb4 30. a4 Rb7 31. Kd3 Rb8 32. Kd4 Re8 33. Ke5 Ng4+ 34. Kf4 Nxe3 35. Kxe3 d5 36. c5 e5 37. Kd3 d4 38. Ke4 Re6 39. g4 Kf7 40. h3 d3 41. Kxd3 Kg6 42. Ke4 Kg5 43. b4 Kh4 44. b5 cxb5 45. axb5 Kxh3 46. b6 Kxg4 47. b7 Re8 48. c6 Kg3 49. c7 h5 50. b8=Q Rc8 51. Qxc8 h4 52. Kxe5 g5 53. Qf5 Kg2 54. Qxg5+ Kh2 55. Qxh4+ Kg2 56. Ke4 Kf1 57. Ke3 1-0	nichiren1967	cheesedout	1645	1867	Rated Bullet game	https://lichess.org/l0g5jkfe	2013-01-01 00:00:00	1-0	l0g5jkfe	2026-02-28 12:47:22.816
de9aea4f-96a7-478d-b5ac-c6cd0ac712ee	[Event "Rated Classical game"]\n[Site "https://lichess.org/upaj7djj"]\n[Date "????.??.??"]\n[Round "?"]\n[White "patan2003"]\n[Black "H4RDY"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "06:49:07"]\n[WhiteElo "1267"]\n[BlackElo "1304"]\n[WhiteRatingDiff "+17"]\n[BlackRatingDiff "-12"]\n[ECO "B01"]\n[Opening "Scandinavian Defense"]\n[TimeControl "420+3"]\n[Termination "Normal"]\n\n1. e4 d5 2. Nc3 d4 3. Nb5 c6 4. c3 dxc3 5. Nxc3 e5 6. Nf3 f6 7. Bc4 g5 8. O-O g4 9. Nh4 Nh6 10. f3 f5 11. fxg4 Qxh4 12. g3 Qh3 13. Rf2 Nxg4 14. Qe2 Nxf2 15. Qxf2 f4 16. gxf4 Rg8+ 17. Kh1 exf4 18. Bxg8 Nd7 19. Qxf4 c5 20. Qf7+ Kd8 21. Nd5 b5 22. d4 cxd4 23. Bg5+ Be7 24. Qxe7# 1-0	patan2003	H4RDY	1267	1304	Rated Classical game	https://lichess.org/upaj7djj	2013-01-01 00:00:00	1-0	upaj7djj	2026-02-28 12:55:18.238
648d14e4-eebf-4a84-ab7b-1f46be7903f9	[Event "Rated Bullet game"]\n[Site "https://lichess.org/muyx35xi"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Yeshi"]\n[Black "xiaoqiao"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "06:56:45"]\n[WhiteElo "2004"]\n[BlackElo "2040"]\n[WhiteRatingDiff "-29"]\n[BlackRatingDiff "+12"]\n[ECO "A01"]\n[Opening "Nimzo-Larsen Attack: Modern Variation #3"]\n[TimeControl "120+0"]\n[Termination "Time forfeit"]\n\n1. b3 e5 2. Bb2 Nc6 3. Nf3 d6 4. e3 f5 5. d4 e4 6. Nfd2 Nf6 7. c4 Ne7 8. Nc3 c5 9. d5 Ng6 10. f3 Qe7 11. fxe4 Nxe4 12. Ndxe4 fxe4 13. Be2 Bf5 14. O-O Qg5 15. Qd2 Be7 16. Rf2 O-O 17. Raf1 Ne5 18. Nb5 Bg4 19. Bxg4 Nxg4 20. Rxf8+ Rxf8 21. Rxf8+ Kxf8 22. Nc7 Qxe3+ 23. Qxe3 Nxe3 24. Ne6+ Kf7 25. Bxg7 Nf5 26. Bc3 e3 27. Kf1 Bf6 28. Bxf6 Kxf6 29. Ke2 h5 30. Nd8 b6 31. Nc6 a5 32. Na7 Ke5 33. Nc8 b5 34. cxb5 Kxd5 35. Nb6+ Ke6 36. Nc4 Nd4+ 37. Kxe3 Nxb5 38. Nd2 Nc3 39. a3 Nd5+ 40. Kf3 a4 41. bxa4 Nc3 42. a5 Nb5 43. a6 Kd7 44. a4 Na7 45. Ne4 Kc6 46. Nf6 h4 47. g3 hxg3 48. hxg3 c4 49. Ke3 Kb6 50. Ne4 d5 51. Nc3 Kc5 52. Nb5 Nc6 53. a7 d4+ 54. Nxd4 Nxa7 55. Ne6+ Kb4 56. Nf4 c3 57. Kd3 Kb3 58. Ne2 c2 59. g4 Kb2 60. Kd2 Nc6 61. g5 Ne5 62. g6 Nxg6 63. a5 Ne5 64. a6 Nc6 65. Nc1 Na7 66. Nd3+ Kb3 67. Nc1+ Kb2 68. Nd3+ Kb1 69. Nc1 Nb5 70. Nd3 Nd4 71. Nc1 Nb3+ 72. Kc3 Nxc1 0-1	Yeshi	xiaoqiao	2004	2040	Rated Bullet game	https://lichess.org/muyx35xi	2013-01-01 00:00:00	0-1	muyx35xi	2026-02-28 12:56:43.777
e39db382-35d2-4114-bd88-d4b22b12cdff	[Event "Rated Classical game"]\n[Site "https://lichess.org/ysyzjjls"]\n[Date "????.??.??"]\n[Round "?"]\n[White "tolik_mmm"]\n[Black "Delaza62"]\n[Result "1/2-1/2"]\n[UTCDate "2013.01.01"]\n[UTCTime "07:01:49"]\n[WhiteElo "1740"]\n[BlackElo "1617"]\n[WhiteRatingDiff "-4"]\n[BlackRatingDiff "+4"]\n[ECO "C50"]\n[Opening "Italian Game: Schilling-Kostic Gambit"]\n[TimeControl "480+5"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 Nc6 3. Bc4 Nd4 4. Nc3 Bc5 5. O-O d6 6. d3 c6 7. Ng5 Nh6 8. Nf3 Be6 9. Bxe6 fxe6 10. Bxh6 gxh6 11. Na4 Qf6 12. Nxd4 exd4 13. Nxc5 dxc5 14. Qh5+ Qg6 15. Qxc5 Rg8 16. g3 h5 17. Qxd4 h4 18. Qd6 h3 19. Qf4 Rf8 20. Qh4 h5 21. Qxh3 O-O-O 22. f4 Kb8 23. a4 c5 24. a5 a6 25. Ra4 Rh8 26. f5 Qg5 27. Qh4 Qe3+ 28. Kh1 exf5 29. exf5 Qe2 30. Qf4+ Ka8 31. Rc4 Qe7 32. Re4 Qf7 33. f6 Rde8 34. Rxe8+ Rxe8 35. Qf5 Re6 36. Qxc5 Rxf6 37. Rxf6 Qxf6 38. Kg2 Qxb2 39. d4 Qc1 40. Qf5 Qd2+ 41. Qf2 Qxa5 42. Qf8+ Ka7 43. Qc5+ Qb6 44. h3 a5 45. g4 hxg4 46. hxg4 a4 47. g5 Qxc5 48. dxc5 a3 49. g6 a2 50. g7 a1=Q 51. g8=Q Qc3 1/2-1/2	tolik_mmm	Delaza62	1740	1617	Rated Classical game	https://lichess.org/ysyzjjls	2013-01-01 00:00:00	1/2-1/2	ysyzjjls	2026-02-28 12:57:48.678
80ed8255-8935-439f-85ec-a9a314a2418c	[Event "Rated Blitz game"]\n[Site "https://lichess.org/zlaqks84"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Atomicangel"]\n[Black "arina1999"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "07:12:25"]\n[WhiteElo "1979"]\n[BlackElo "2161"]\n[WhiteRatingDiff "-6"]\n[BlackRatingDiff "+7"]\n[ECO "C82"]\n[Opening "Ruy Lopez: Open Variations, Dilworth Variation"]\n[TimeControl "180+0"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 5. O-O Nxe4 6. d4 b5 7. Bb3 d5 8. dxe5 Be6 9. Nbd2 Bc5 10. c3 O-O 11. Bc2 Nxf2 12. Rxf2 f6 13. Nf1 Bxf2+ 14. Kxf2 fxe5 15. Kg1 e4 16. Ng5 Qf6 17. Ng3 Rad8 18. Be3 h6 19. Nxe6 Qxe6 20. Qe2 Ne5 21. Bd4 c6 22. Nxe4 Rde8 23. Nc5 Qe7 24. Qh5 Nc4 25. Bg6 Qe1+ 0-1	Atomicangel	arina1999	1979	2161	Rated Blitz game	https://lichess.org/zlaqks84	2013-01-01 00:00:00	0-1	zlaqks84	2026-02-28 12:59:48.934
770cc351-45f6-49aa-b5cf-bfc80ca5bbd2	[Event "Rated Bullet game"]\n[Site "https://lichess.org/4e03mu47"]\n[Date "????.??.??"]\n[Round "?"]\n[White "BulletPlay"]\n[Black "ptdhina"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "08:18:14"]\n[WhiteElo "1577"]\n[BlackElo "1511"]\n[WhiteRatingDiff "+26"]\n[BlackRatingDiff "-9"]\n[ECO "A00"]\n[Opening "Mieses Opening: Reversed Rat"]\n[TimeControl "0+1"]\n[Termination "Time forfeit"]\n\n1. d3 e5 2. e3 Nc6 3. c3 d5 4. b4 Be6 5. Bb2 Qb8 6. Be2 a6 7. c4 dxc4 8. dxc4 Bxb4+ 9. Nc3 Bxc3+ 10. Bxc3 Nf6 11. Nf3 O-O 12. Nxe5 Nxe5 13. Bxe5 Qd8 14. Qxd8 Raxd8 15. Bxc7 Rc8 16. Bb6 Bxc4 17. Bxc4 Rxc4 18. O-O Nd5 19. Ba5 Rb8 20. a3 g6 21. Rac1 Rxc1 22. Rxc1 Nf6 23. Bc3 Ne4 24. Be5 Rd8 25. Bc7 Rd7 26. Be5 Nc5 27. f3 Rd3 28. e4 Nb3 29. Rc3 1-0	BulletPlay	ptdhina	1577	1511	Rated Bullet game	https://lichess.org/4e03mu47	2013-01-01 00:00:00	1-0	4e03mu47	2026-02-28 13:08:31.017
9451a7ea-5d71-41d3-a776-ccb546caf693	[Event "Rated Classical game"]\n[Site "https://lichess.org/4qv7t7mc"]\n[Date "????.??.??"]\n[Round "?"]\n[White "patan2003"]\n[Black "Eldorado"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "08:21:54"]\n[WhiteElo "1319"]\n[BlackElo "1223"]\n[WhiteRatingDiff "-17"]\n[BlackRatingDiff "+16"]\n[ECO "C40"]\n[Opening "Elephant Gambit"]\n[TimeControl "420+3"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 d5 3. Nc3 d4 4. Nb5 Na6 5. Nxe5 Nf6 6. c3 Nxe4 7. Nxd4 Qf6 8. Qh5 g6 9. Nxg6 Qxf2+ 10. Kd1 fxg6 11. Qe5+ Kd8 12. Qd5+ Bd6 13. Qxe4 Re8 14. Qxe8+ Kxe8 15. Bb5+ c6 16. Re1+ Kf7 17. Bc4+ Kg7 18. Ne6+ Kh6 19. d4+ Kh5 20. Ng7+ Kg4 21. h3+ Kg3 22. Re3+ Kh2 23. Re2 Qf1+ 24. Re1 Qxg2 25. Re2 Bxh3 26. Rxg2+ Bxg2 27. Nf5 Bf3+ 28. Ke1 Re8+ 29. Kf2 Bh5 30. Ng7 Bg3+ 31. Kf1 Re1# 0-1	patan2003	Eldorado	1319	1223	Rated Classical game	https://lichess.org/4qv7t7mc	2013-01-01 00:00:00	0-1	4qv7t7mc	2026-02-28 13:09:14.598
ee70d29d-2790-484f-9562-3d3ac511286f	[Event "Rated Classical game"]\n[Site "https://lichess.org/3hxq7ou0"]\n[Date "????.??.??"]\n[Round "?"]\n[White "jsalemal-55"]\n[Black "famcaliap"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "08:30:28"]\n[WhiteElo "1612"]\n[BlackElo "1724"]\n[WhiteRatingDiff "+15"]\n[BlackRatingDiff "-14"]\n[ECO "C34"]\n[Opening "King's Gambit Accepted, King's Knight Gambit"]\n[TimeControl "900+12"]\n[Termination "Normal"]\n\n1. e4 e5 2. f4 exf4 3. Nf3 Bc5 4. d4 Bb6 5. c4 Ba5+ 6. Nc3 Bxc3+ 7. bxc3 Ne7 8. Bxf4 O-O 9. e5 Ng6 10. Be3 d6 11. Bd3 Bg4 12. O-O dxe5 13. Bxg6 Bxf3 14. Bxh7+ Kxh7 15. Qxf3 Kg8 16. dxe5 Nc6 17. Rad1 Nxe5 18. Qxb7 Qc8 19. Qd5 Ng4 20. Bd4 Qe6 21. Qg5 Qg6 22. Qd5 Qh6 23. h3 Nf6 24. Bxf6 gxf6 25. Qc6 Qe3+ 26. Kh1 Qxc3 27. Rxf6 Qc2 28. Qf3 Qh7 29. Rd7 Rab8 30. Rxc7 Rbc8 31. Rxc8 Rxc8 32. Qg4+ Qg7 33. Qxc8+ 1-0	jsalemal-55	famcaliap	1612	1724	Rated Classical game	https://lichess.org/3hxq7ou0	2013-01-01 00:00:00	1-0	3hxq7ou0	2026-02-28 13:10:36.104
d936f9fd-e4f9-496f-9194-671386190639	[Event "Rated Classical game"]\n[Site "https://lichess.org/cogm6ife"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Marzinkus"]\n[Black "troepianiz"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "08:27:50"]\n[WhiteElo "1882"]\n[BlackElo "1692"]\n[WhiteRatingDiff "-17"]\n[BlackRatingDiff "+16"]\n[ECO "C62"]\n[Opening "Ruy Lopez: Steinitz Defense"]\n[TimeControl "300+8"]\n[Termination "Normal"]\n\n1. e4 e5 2. Nf3 Nc6 3. Bb5 d6 4. d4 exd4 5. Nxd4 Bd7 6. Bxc6 Bxc6 7. Nxc6 bxc6 8. Nc3 Qf6 9. O-O Be7 10. Bd2 Nh6 11. a3 O-O 12. h3 Qh4 13. f4 Qf6 14. Qh5 Kh8 15. b4 Qd4+ 16. Rf2 Ng8 17. Rd1 Nf6 18. Qf3 a5 19. Bc1 Qb6 20. Be3 Qb7 21. bxa5 Rxa5 22. Rb1 Qa6 23. e5 dxe5 24. fxe5 Nd5 25. Ne4 Rxa3 26. Rb3 Ra1+ 27. Kh2 Bh4 28. g3 Be7 29. Bg5 Qa5 30. Bxe7 Nxe7 31. Qh5 Ng6 32. Rb7 Qe1 33. Ng5 0-1	Marzinkus	troepianiz	1882	1692	Rated Classical game	https://lichess.org/cogm6ife	2013-01-01 00:00:00	0-1	cogm6ife	2026-02-28 13:12:17.39
05e1c848-91ad-46ae-9a3e-db9493ad6f14	[Event "Rated Classical game"]\n[Site "https://lichess.org/68b00b61"]\n[Date "????.??.??"]\n[Round "?"]\n[White "2013_January"]\n[Black "akayhan"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "08:45:55"]\n[WhiteElo "1946"]\n[BlackElo "1648"]\n[WhiteRatingDiff "+36"]\n[BlackRatingDiff "-4"]\n[ECO "C21"]\n[Opening "Center Game"]\n[TimeControl "300+20"]\n[Termination "Normal"]\n\n1. e4 e5 2. d4 exd4 3. Qxd4 Nf6 4. e5 Qe7 5. f4 Qb4+ 6. c3 Qxd4 7. cxd4 Bb4+ 8. Bd2 Bxd2+ 9. Nxd2 Nd5 10. Ne4 Nxf4 11. g3 Nd5 12. Ng5 O-O 13. Bc4 Ne3 14. Bd3 g6 15. h4 d6 16. h5 dxe5 17. hxg6 fxg6 18. N1f3 exd4 19. Rxh7 Nf5 20. O-O-O Ne3 21. Rdh1 Bf5 22. Rh8+ Kg7 23. R1h7+ Kf6 24. Rxf8# 1-0	2013_January	akayhan	1946	1648	Rated Classical game	https://lichess.org/68b00b61	2013-01-01 00:00:00	1-0	68b00b61	2026-02-28 13:13:28.236
a54499f8-092c-41ce-9b29-ea77fc0327fc	[Event "Rated Blitz game"]\n[Site "https://lichess.org/dak3zn1a"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Last-Soldier"]\n[Black "maslick"]\n[Result "0-1"]\n[UTCDate "2013.01.01"]\n[UTCTime "09:07:15"]\n[WhiteElo "1620"]\n[BlackElo "1639"]\n[WhiteRatingDiff "-11"]\n[BlackRatingDiff "+31"]\n[ECO "D02"]\n[Opening "Queen's Pawn Game: Zukertort Variation"]\n[TimeControl "300+3"]\n[Termination "Normal"]\n\n1. d4 d5 2. Nf3 c6 3. g3 Nf6 4. Bg2 Bf5 5. h3 Nbd7 6. O-O e6 7. Nbd2 Bd6 8. Nh4 Bg6 9. Nxg6 fxg6 10. c4 b6 11. a3 O-O 12. e4 dxe4 13. Nxe4 Bc7 14. Nxf6+ Nxf6 15. Bxc6 Rb8 16. Bg2 Qe7 17. d5 Rbd8 18. Bg5 Qc5 19. Be3 Qe7 20. Qb3 Rd7 21. dxe6 Qxe6 22. Rfe1 Qf7 23. Bg5 h6 24. Bxf6 Qxf6 25. c5+ Kh7 26. c6 Qxf2+ 27. Kh1 Rdd8 28. Rf1 Qxg3 29. Qc2 Qh2# 0-1	Last-Soldier	maslick	1620	1639	Rated Blitz game	https://lichess.org/dak3zn1a	2013-01-01 00:00:00	0-1	dak3zn1a	2026-02-28 13:16:32.16
858199a5-08f6-4718-8e35-3ea34c6b24cd	[Event "Rated Classical game"]\n[Site "https://lichess.org/rfadu3q0"]\n[Date "????.??.??"]\n[Round "?"]\n[White "Voltvolf"]\n[Black "cirilek"]\n[Result "1-0"]\n[UTCDate "2013.01.01"]\n[UTCTime "09:11:58"]\n[WhiteElo "1824"]\n[BlackElo "1645"]\n[WhiteRatingDiff "+6"]\n[BlackRatingDiff "-6"]\n[ECO "B01"]\n[Opening "Scandinavian Defense: Mieses-Kotroc Variation"]\n[TimeControl "420+3"]\n[Termination "Normal"]\n\n1. e4 d5 2. exd5 Qxd5 3. Nc3 Qd8 4. Nf3 c6 5. Bc4 Bf5 6. d3 e6 7. Bf4 h6 8. Qd2 Nf6 9. h3 Nbd7 10. O-O-O Qa5 11. Kb1 O-O-O 12. g4 Bh7 13. Rhe1 Nb6 14. Bb3 Nbd5 15. Nxd5 Qxd2 16. Bxd2 Nxd5 17. Ne5 Bg8 18. f4 Ne7 19. Be3 Kb8 20. f5 f6 21. Nc4 e5 22. d4 exd4 23. Rxd4 Rxd4 24. Bxd4 Nd5 25. Ne3 Bb4 26. c3 Ba5 27. Nxd5 Bxd5 28. Bxd5 cxd5 29. Re7 Bb6 30. Bxb6 axb6 31. Rxg7 Rc8 32. Rg6 h5 33. Rxf6 hxg4 34. hxg4 Rc6 35. Rf8+ Kc7 36. g5 Kd6 37. Re8 Kd7 38. Re5 Kd6 39. Re6+ Kd7 40. Rxc6 bxc6 41. g6 Ke7 42. Kc2 Kf6 43. Kd3 c5 44. b4 Kg7 45. a4 Kf6 46. bxc5 bxc5 47. a5 1-0	Voltvolf	cirilek	1824	1645	Rated Classical game	https://lichess.org/rfadu3q0	2013-01-01 00:00:00	1-0	rfadu3q0	2026-02-28 13:17:14.64
\.


--
-- Data for Name: Puzzle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Puzzle" (id, fen, moves, rating, "ratingDeviation", volatility, "solveCount", "failCount", themes, "gamePhase", "openingEco", "openingName", "likeCount", "dislikeCount", "isActive", "sourceGameId", "moveIndex", "createdAt", "updatedAt", "blunderMove", "preBblunderFen") FROM stdin;
CuoZr	2k5/1p1r3p/p5p1/2pNRnP1/P1r2P2/8/1PP5/2K2R2 b - - 5 27	{d7d5,e5d5,f5e3}	2109	350	0.06	0	0	{DECOY}	MIDDLEGAME	B21	Sicilian Defense: McDonnell Attack	0	0	t	d70c5941-6492-4247-b9ba-3e27bfb08013	52	2026-02-28 11:06:15.817	2026-02-28 11:06:15.817	c3d5	2k5/1p1r3p/p5p1/2p1RnP1/P1r2P2/2N5/1PP5/2K2R2 w - - 4 27
HEWRN	8/5pkp/6p1/8/1Pb5/2r3P1/4BP1P/4RK2 w - - 5 38	{e2c4,c3c4,e1b1}	1991	350	0.06	0	0	{HANGING_PIECE}	MIDDLEGAME	A15	English Opening: Anglo-Indian Defense, King's Knight Variation	0	0	t	f06a982a-03b8-4ca7-8abe-9bf7874d8123	73	2026-02-28 11:10:04.376	2026-02-28 11:10:04.376	d5c4	8/5pkp/6p1/3b4/1P6/2r3P1/4BP1P/4RK2 b - - 4 37
56jwK	4R3/p5pk/7p/8/Pb4P1/6PK/2r1B3/8 w - - 0 43	{e2d3,g7g6,d3c2}	1471	350	0.06	0	0	{TRAP,FORK}	ENDGAME	C55	Italian Game: Two Knights Defense, Modern Bishop's Opening	0	0	t	52bc6550-ea2f-444e-a203-de0e4afb3bf2	83	2026-02-28 11:10:40.801	2026-02-28 11:10:40.801	c3b4	4R3/p5pk/7p/8/PP4P1/2b3PK/2r1B3/8 b - - 8 42
St3XL	4q1k1/p4p2/1p1p2pp/2nP1n2/2P2B2/P5PN/2Q2P1P/6K1 b - - 1 25	{e8e1,g1g2,f5d4}	1816	350	0.06	0	0	{HANGING_PIECE}	MIDDLEGAME	A04	Zukertort Opening: Queenside Fianchetto Variation	0	0	t	5c4cc43f-efd9-4de8-93ea-b21cbd32bca4	48	2026-02-28 11:16:05.152	2026-02-28 11:16:05.152	g5h3	4q1k1/p4p2/1p1p2pp/2nP1nN1/2P2B2/P5P1/2Q2P1P/6K1 w - - 0 25
bHBHu	4k2r/R3b3/2q1p3/2p1Pp2/3p1PQn/1P3P1p/2P4P/R6K w k - 0 28	{a7e7,e8d8,e7e6}	1903	350	0.06	0	0	{TRAP,BACK_RANK,DECOY}	MIDDLEGAME	B01	Scandinavian Defense	0	0	t	6d5fb904-8a18-4d57-9fa8-502d76b619d4	53	2026-02-28 11:23:19.65	2026-02-28 11:23:19.65	g6f5	4k2r/R3b3/2q1p1p1/2p1PN2/3p1PQn/1P3P1p/2P4P/R6K b k - 0 27
IRkdB	1r2r1k1/pb4pp/8/2p5/2PpBq2/3Q1P2/PP4PP/R2R2K1 b - - 2 23	{b7e4,f3e4,b8b2}	1985	350	0.06	0	0	{DEFLECTION,DECOY}	MIDDLEGAME	B40	Sicilian Defense: French Variation	0	0	t	078ad0b7-7403-4539-af4b-963b6b041c20	44	2026-02-28 11:23:51.207	2026-02-28 11:23:51.207	e2d3	1r2r1k1/pb4pp/8/2p5/2PpBq2/5P2/PP2Q1PP/R2R2K1 w - - 1 23
qqUZI	r1b1k1r1/p1pq1p1p/1p1p1p2/4p3/1PBnP3/P2P2P1/2PQNP1P/R3K2R b KQq - 1 15	{d4f3,e1d1,f3d2}	1562	350	0.06	0	0	{TRAP,FORK}	OPENING	C28	Bishop's Opening: Vienna Hybrid	0	0	t	22fc9667-a22a-4677-882f-a8ffcbfeab7f	28	2026-02-28 11:25:14.774	2026-02-28 11:25:14.774	g1e2	r1b1k1r1/p1pq1p1p/1p1p1p2/4p3/1PBnP3/P2P2P1/2PQ1P1P/R3K1NR w KQq - 0 15
tsaPl	r7/8/5p2/3p1Pp1/Pp3kP1/1P1R4/5K2/8 w - - 3 44	{d3d4,f4e5,d4b4}	1573	350	0.06	0	0	{ROOK_ENDGAME}	ENDGAME	B01	Scandinavian Defense: Modern Variation #2	0	0	t	6d8350f9-08c4-4cdf-b53e-f6fa0f5a52e6	85	2026-02-28 11:25:34.583	2026-02-28 11:25:34.583	e5f4	r7/8/5p2/3pkPp1/Pp4P1/1P1R4/5K2/8 b - - 2 43
wnmKU	rn2kbnr/1b2pppp/ppq5/8/5B2/1NPB1NP1/PP2QP1P/R4RK1 b kq - 5 13	{c6f3,e2f3,b7f3}	1459	350	0.06	0	0	{QUEEN_SACRIFICE,DECOY}	OPENING	B07	Pirc Defense #5	0	0	t	38d57805-9ea9-45e5-ac09-9ae1ba396079	24	2026-02-28 11:26:46.78	2026-02-28 11:26:46.78	d2b3	rn2kbnr/1b2pppp/ppq5/8/5B2/2PB1NP1/PP1NQP1P/R4RK1 w kq - 4 13
2Qxuf	rn2k1nr/1b2qpp1/ppppp3/8/2PPPP2/3Q2p1/PP2B1P1/RN2BRK1 b kq - 0 16	{h8h1,g1h1,e7h4,h1g1,h4h2}	1719	350	0.06	0	0	{SKEWER,MATE_IN_3,BACK_RANK}	MIDDLEGAME	A00	Gedult's Opening	0	0	t	81065b53-0332-456f-83ea-47c0b0a51c85	30	2026-02-28 11:28:28.27	2026-02-28 11:28:28.27	f3f4	rn2k1nr/1b2qpp1/ppppp3/8/2PPP3/3Q1Pp1/PP2B1P1/RN2BRK1 w kq - 2 16
aCRau	r1b1r1k1/pp1n1p1p/2pb1PpB/3Np3/2B1P3/8/PPP3PP/3R1RK1 w - - 0 18	{d5e7,d6e7,f6e7}	1615	350	0.06	0	0	{FORK,DISCOVERED_ATTACK,PIN,TRAP,DECOY}	MIDDLEGAME	C44	Scotch Game	0	0	t	ae904a1e-7d92-4b5b-9a06-82b41c4d967e	33	2026-02-28 11:28:36.343	2026-02-28 11:28:36.343	c7c6	r1b1r1k1/pppn1p1p/3b1PpB/3Np3/2B1P3/8/PPP3PP/3R1RK1 b - - 4 17
FKl88	r4rk1/pp4pp/2qpb3/4p3/1PPp4/P2P1PPP/3BB1n1/R2Q1K1R b - - 0 17	{g2e3,d2e3,d4e3}	1441	350	0.06	0	0	{TRAP,FORK,DECOY}	MIDDLEGAME	A10	English Opening	0	0	t	93ff3559-d965-4220-9ebf-0674c9fe72b0	32	2026-02-28 11:30:38.745	2026-02-28 11:30:38.745	f2f3	r4rk1/pp4pp/2qpb3/4p3/1PPp4/P2P2PP/3BBPn1/R2Q1K1R w - - 3 17
VE1Ro	1k1r4/ppp2Pb1/7p/2Q3p1/2B5/5PB1/PPK2P1P/4q3 w - - 6 24	{c5c7,b8a8,c7d8}	1760	350	0.06	0	0	{FORK,QUEEN_SACRIFICE,MATE_IN_2,BACK_RANK,TRAP}	MIDDLEGAME	D20	Queen's Gambit Accepted	0	0	t	39cbdc2f-46a5-49fe-9bf2-1760508a5e9a	45	2026-02-28 11:30:51.388	2026-02-28 11:30:51.388	f8d8	1k3r2/ppp2Pb1/7p/2Q3p1/2B5/5PB1/PPK2P1P/4q3 b - - 5 23
NttRj	2kr3r/1pp1qpb1/Bnn1p2p/2N1P1p1/3P4/P4PB1/1PQ2P1P/2KR3R w - - 1 18	{a6b7,c8b8,b7c6}	1681	350	0.06	0	0	{TRAP,FORK,DEFLECTION}	MIDDLEGAME	D20	Queen's Gambit Accepted	0	0	t	c7a36624-3a4d-4c8a-9cf1-9d3c4e95e4b5	33	2026-02-28 11:31:56.945	2026-02-28 11:31:56.945	d5b6	2kr3r/1pp1qpb1/B1n1p2p/2NnP1p1/3P4/P4PB1/1PQ2P1P/2KR3R b - - 0 17
1oBhZ	2kr3r/1pp1qpb1/1nn1p2p/1BN1P1p1/3P4/P4PB1/1PQ2P1P/2KR3R b - - 2 18	{c6d4,d1d4,d8d4}	1681	350	0.06	0	0	{FORK,DEFLECTION,DECOY}	MIDDLEGAME	D20	Queen's Gambit Accepted	0	0	t	c7a36624-3a4d-4c8a-9cf1-9d3c4e95e4b5	34	2026-02-28 11:31:56.945	2026-02-28 11:31:56.945	a6b5	2kr3r/1pp1qpb1/Bnn1p2p/2N1P1p1/3P4/P4PB1/1PQ2P1P/2KR3R w - - 1 18
4hUXg	rnbqkbnr/pppp2pp/5p2/4N3/3Pp3/4P3/PPP2PPP/RNBQKB1R w KQkq - 0 5	{d1h5,g7g6,e5g6}	1669	350	0.06	0	0	{HANGING_PIECE}	OPENING	A40	Horwitz Defense	0	0	t	7b55a173-d1b0-4452-8885-55c62f92bede	7	2026-02-28 11:36:54.851	2026-02-28 11:36:54.851	f7f6	rnbqkbnr/pppp1ppp/8/4N3/3Pp3/4P3/PPP2PPP/RNBQKB1R b KQkq - 1 4
tUr19	2kr4/b1r4p/4R1p1/5P2/1P2P3/2P2K1P/1P6/3R4 w - - 6 35	{d1d8,c8d8,f5f6}	1769	350	0.06	0	0	{DEFLECTION}	MIDDLEGAME	D00	Queen's Pawn Game #2	0	0	t	afb159c5-9ac9-4b13-aab8-2c3ef7f591d6	67	2026-02-28 11:38:56.146	2026-02-28 11:38:56.146	h8d8	2k4r/b1r4p/4R1p1/5P2/1P2P3/2P2K1P/1P6/3R4 b - - 5 34
afw52	2r3k1/p3Qppp/3p1q2/3P4/8/1P6/r4PPP/4RRK1 w - - 2 26	{e7e8,c8e8,e1e8}	1503	268.6663503443526	0.05999918411490512	1	0	{FORK,QUEEN_SACRIFICE,MATE_IN_2,BACK_RANK,TRAP,INTERFERENCE,DECOY}	MIDDLEGAME	C26	Vienna Game: Stanley Variation	0	1	t	b5254822-0ed4-4620-badc-c98df0c620c5	49	2026-02-28 11:22:14.638	2026-02-28 15:14:55.505	f5f6	2r3k1/p3Qppp/3p4/3P1q2/8/1P6/r4PPP/4RRK1 b - - 1 25
MoI29	rnbqkbnr/pp6/2ppp3/4N3/6Q1/1PPPP1Pp/P6P/RNB1KB1R w KQkq - 0 11	{g4g6,e8e7,g6f7}	1298	308.7877954590954	0.05999933304853034	1	0	{MATE_IN_2,FORK,TRAP}	OPENING	A00	Mieses Opening	0	0	t	a99be7fc-749c-4b01-a959-b89dd9d19f86	19	2026-02-28 11:34:48.927	2026-03-01 03:17:40.819	c7c6	rnbqkbnr/ppp5/3pp3/4N3/6Q1/1PPPP1Pp/P6P/RNB1KB1R b KQkq - 0 10
dbsOx	r4rk1/p1q2pb1/1p5p/4p1p1/1nP1N3/4BQ2/PP3PPP/R2R2K1 w - - 2 19	{e4f6,g7f6,f3f6}	1659	350	0.06	0	0	{TRAP,DECOY}	MIDDLEGAME	A00	Van't Kruijs Opening	0	0	t	142d3e0a-eaed-406d-ac06-b44468d50c74	35	2026-02-28 11:39:53.971	2026-02-28 11:39:53.971	c6b4	r4rk1/p1q2pb1/1pn4p/4p1p1/2P1N3/4BQ2/PP3PPP/R2R2K1 b - - 1 18
0Nrtu	rn1qk2r/pp1n2pp/2pbpp2/3pN3/3P1P2/4P3/PPP1Q1PP/RNB2RK1 w kq - 0 10	{e2h5,g7g6,e5g6,h7g6,h5h8}	2057	350	0.06	0	0	{TRAP}	OPENING	A40	Queen's Pawn	0	0	t	98b3ea45-e976-4855-a0e4-626bc61bc4eb	17	2026-02-28 11:40:22.521	2026-02-28 11:40:22.521	f7f6	rn1qk2r/pp1n1ppp/2pbp3/3pN3/3P1P2/4P3/PPP1Q1PP/RNB2RK1 b kq - 4 9
LDLip	8/8/8/p3R3/7p/PP3k2/2r5/5K2 b - - 3 51	{c2c1,e5e1,c1e1,f1e1,h4h3}	1723	350	0.06	0	0	{BACK_RANK,ROOK_ENDGAME}	ENDGAME	B20	Sicilian Defense: Bowdler Attack	0	0	t	500cb63e-f18f-4776-acd0-c6db605d94b7	100	2026-02-28 11:41:20.415	2026-02-28 11:41:20.415	b5e5	8/8/8/pR6/7p/PP3k2/2r5/5K2 w - - 2 51
GfosL	8/8/8/pP2R3/7p/r4k2/8/5K2 b - - 0 53	{a3a1,e5e1,a1e1,f1e1,h4h3}	1623	350	0.06	0	0	{BACK_RANK,ROOK_ENDGAME}	ENDGAME	B20	Sicilian Defense: Bowdler Attack	0	0	t	500cb63e-f18f-4776-acd0-c6db605d94b7	104	2026-02-28 11:41:20.415	2026-02-28 11:41:20.415	b4b5	8/8/8/p3R3/1P5p/r4k2/8/5K2 w - - 0 53
2QI01	r1b3k1/ppq2ppp/3b4/6Pn/3Q3P/1P6/PBP2P2/4R1K1 w - - 1 22	{e1e8,d6f8,d4b4}	1606	350	0.06	0	0	{TRAP,FORK,BACK_RANK}	MIDDLEGAME	A00	Van't Kruijs Opening	0	0	t	00b0a79f-e275-4a00-847b-675b89959cf4	41	2026-02-28 11:43:29.906	2026-02-28 11:43:29.906	d8c7	r1bq2k1/pp3ppp/3b4/6Pn/3Q3P/1P6/PBP2P2/4R1K1 b - - 0 21
ReosY	2krr3/Q4p2/R1pq1n1p/3p2n1/8/1BN5/1PP4b/1K1R4 w - - 3 26	{c3a4,d8d7,a7a8,d6b8,a8c6}	1663	350	0.06	0	0	{HANGING_PIECE}	MIDDLEGAME	C00	French Defense #2	0	0	t	34e2a088-046a-4101-b005-d7d4a406e884	49	2026-02-28 11:45:05.366	2026-02-28 11:45:05.366	f4d6	2krr3/Q4p2/R1p2n1p/3p2n1/5q2/1BN5/1PP4b/1K1R4 b - - 2 25
agLqC	r3r2k/1p4pp/2p5/8/4q3/p6P/R1Q3P1/5R1K w - - 0 32	{f1f8,e8f8,c2e4}	1969	350	0.06	0	0	{FORK,SKEWER,BACK_RANK,TRAP,INTERFERENCE,DECOY}	MIDDLEGAME	D37	Queen's Gambit Declined: Harrwitz Attack, Orthodox Defense	0	0	t	beeb4f4b-9a80-4d45-acc1-d2cfb4bc4514	61	2026-02-28 11:54:29.782	2026-02-28 11:54:29.782	e5e4	r3r2k/1p4pp/2p5/4q3/4P3/p6P/R1Q3P1/5R1K b - - 1 31
E1yzi	8/8/8/1kq4p/2Qp4/1P4P1/1K6/8 b - - 15 61	{c5c4,b3c4,b5c4}	1700	350	0.06	0	0	{QUEEN_SACRIFICE}	ENDGAME	C00	French Defense: Knight Variation	0	0	t	e6bacf32-dbb3-4892-ab00-5d2a44273e55	120	2026-02-28 11:56:03.953	2026-02-28 11:56:03.953	e6c4	8/8/4Q3/1kq4p/3p4/1P4P1/1K6/8 w - - 14 61
14pDP	5rk1/5ppp/p6q/8/2p1p3/2P2PP1/PP2Q3/3R1K2 b - - 0 32	{h6h1,f1f2,e4e3}	1690	350	0.06	0	0	{SKEWER}	MIDDLEGAME	A00	Van't Kruijs Opening	0	0	t	5186ccb2-05a8-410c-8ece-6c7bf864b432	62	2026-02-28 11:57:58.487	2026-02-28 11:57:58.487	f2f3	5rk1/5ppp/p6q/8/2p1p3/2P3P1/PP2QP2/3R1K2 w - - 1 32
eUfFe	3N2k1/p1Q2p1p/1p2pbp1/1N6/4P3/P6P/2r2PP1/6K1 b - - 0 25	{c2c7,b5c7,f6d8}	1475	350	0.06	0	0	{TRAP}	MIDDLEGAME	B06	Modern Defense	0	0	t	ad5546be-050b-4167-aea0-2aa66709b1dc	48	2026-02-28 12:02:25.636	2026-02-28 12:02:25.636	c6d8	3r2k1/p1Q2p1p/1pN1pbp1/1N6/4P3/P6P/2r2PP1/6K1 w - - 0 25
irj0d	3r2k1/r4ppp/2R5/8/PP6/8/3pKPPP/R7 b - - 0 28	{a7e7,e2f3,e7e1}	1487	350	0.06	0	0	{ROOK_ENDGAME}	MIDDLEGAME	B45	Sicilian Defense: Paulsen Variation, Normal Variation	0	0	t	1c3c0dd0-9260-43f8-b08c-128f570be6a5	54	2026-02-28 12:02:33.946	2026-02-28 12:02:33.946	a3a4	3r2k1/r4ppp/2R5/8/1P6/P7/3pKPPP/R7 w - - 2 28
AWcJ1	3r2k1/pp3ppp/2p1p3/4P1PP/8/4PQ2/P1qr4/R4RK1 w - - 2 25	{f3f7,g8h8,f7f8,d8f8,f1f8}	1688	350	0.06	0	0	{QUEEN_SACRIFICE,MATE_IN_3,BACK_RANK}	MIDDLEGAME	B01	Scandinavian Defense: Mieses-Kotroc Variation	0	0	t	23deb475-48e7-4b64-8b37-a0daf3b3018d	47	2026-02-28 12:03:39.561	2026-02-28 12:03:39.561	f8d8	5rk1/pp3ppp/2p1p3/4P1PP/8/4PQ2/P1qr4/R4RK1 b - - 1 24
61fOz	3r2k1/pp4pp/2p1p1p1/4P2P/8/4PQ2/P1qr4/R4RK1 w - - 0 26	{f3f7,g8h8,f7f8,d8f8,f1f8}	1688	350	0.06	0	0	{QUEEN_SACRIFICE,MATE_IN_3,BACK_RANK}	MIDDLEGAME	B01	Scandinavian Defense: Mieses-Kotroc Variation	0	0	t	23deb475-48e7-4b64-8b37-a0daf3b3018d	49	2026-02-28 12:03:39.561	2026-02-28 12:03:39.561	f7g6	3r2k1/pp3ppp/2p1p1P1/4P2P/8/4PQ2/P1qr4/R4RK1 b - - 0 25
BzPKO	8/5kp1/4p3/1PR2pKP/5P2/1r6/8/8 b - - 4 60	{b3g3,g5h4,g3g4,h4h3,g4f4}	1870	350	0.06	0	0	{ROOK_ENDGAME}	ENDGAME	D02	Queen's Pawn Game: Zukertort Variation	0	0	t	bf2ba10f-b1a0-4c36-bb8c-223264345a63	118	2026-02-28 12:04:26.483	2026-02-28 12:04:26.483	h4g5	8/5kp1/4p3/1PR2p1P/5P1K/1r6/8/8 w - - 3 60
F7TG9	rnbqk2r/1ppp2pp/p4p2/4P3/4Q3/n4N2/P1P2PPP/2KR1B1R w kq - 0 11	{e5f6,e8f8,f6g7}	1403	350	0.06	0	0	{DISCOVERED_ATTACK}	OPENING	C42	Russian Game: Three Knights Game	0	0	t	03c99112-0d29-4cc3-a7e2-c66ef88ea4eb	19	2026-02-28 12:05:57.855	2026-02-28 12:05:57.855	b5a3	rnbqk2r/1ppp2pp/p4p2/1n2P3/4Q3/B4N2/P1P2PPP/2KR1B1R b kq - 1 10
uFiEJ	r1b3k1/pp4pp/4qp2/4p3/2p5/2P2NP1/P1Q2PP1/3R2K1 w - - 2 23	{d1d8,g8f7,c2h7}	1852	350	0.06	0	0	{TRAP,FORK}	MIDDLEGAME	D31	Queen's Gambit Declined: Queen's Knight Variation	0	0	t	4f543547-b5ab-43fe-ab18-fd15d07faf37	43	2026-02-28 12:06:36.107	2026-02-28 12:06:36.107	d5e6	r1b3k1/pp4pp/5p2/3qp3/2p5/2P2NP1/P1Q2PP1/3R2K1 b - - 1 22
kjpJO	r5k1/2p3pp/p1q1p3/7Q/2p5/2Pp2P1/PP5P/5RK1 w - - 0 31	{h5f7,g8h8,f7f8,a8f8,f1f8}	1582	350	0.06	0	0	{QUEEN_SACRIFICE,MATE_IN_3,BACK_RANK}	MIDDLEGAME	B02	Alekhine Defense: Maroczy Variation	0	0	t	e226d590-2378-4c7f-91a4-b7c6b87e47ba	59	2026-02-28 12:06:51.349	2026-02-28 12:06:51.349	d4d3	r5k1/2p3pp/p1q1p3/7Q/2pp4/2P3P1/PP5P/5RK1 b - - 1 30
yBi42	1r1r2k1/p4ppp/4pb2/8/4B3/K3B1P1/P3QP1q/R3R3 b - - 4 28	{f6e7,a3a4,b8b4}	1703	350	0.06	0	0	{HANGING_PIECE}	MIDDLEGAME	A06	Zukertort Opening: Tennison Gambit	0	0	t	a487b77d-d378-44d1-81c2-0004289b1232	54	2026-02-28 12:07:56.873	2026-02-28 12:07:56.873	b3a3	1r1r2k1/p4ppp/4pb2/8/4B3/1K2B1P1/P3QP1q/R3R3 w - - 3 28
7Yj2H	2r3k1/1p3ppp/p4n2/3p1P2/P2Pp3/1P2P1Q1/3q2PP/1RrR2K1 w - - 13 28	{b1c1,d2c1,d1c1,c8c1,g1f2}	1865	350	0.06	0	0	{DEFLECTION,DECOY}	MIDDLEGAME	A40	Horwitz Defense	0	0	t	f5779728-b667-4daf-b9d1-a661f39ae684	53	2026-02-28 12:09:40.462	2026-02-28 12:09:40.462	c2c1	2r3k1/1p3ppp/p4n2/3p1P2/P2Pp3/1P2P1Q1/2rq2PP/1R1R2K1 b - - 12 27
pjJZ3	4r1k1/p4ppp/8/P2pq2b/8/1BP5/1Q3PPP/R5K1 b - - 0 26	{e5e1,a1e1,e8e1}	1853	350	0.06	0	0	{FORK,QUEEN_SACRIFICE,MATE_IN_2,BACK_RANK,TRAP,INTERFERENCE,DECOY}	MIDDLEGAME	B40	Sicilian Defense: Marshall Counterattack	0	0	t	c3330430-77c2-436f-a62c-bed19d9def89	50	2026-02-28 12:11:04.879	2026-02-28 12:11:04.879	a4a5	4r1k1/p4ppp/8/3pq2b/P7/1BP5/1Q3PPP/R5K1 w - - 0 26
dDlgZ	r3kbnr/pp1b2pp/1q3p2/3Qn3/3pP3/3P1N2/PP1BN1PP/2R1KB1R b Kkq - 3 13	{e5d3,e1d1,d3b2}	1879	350	0.06	0	0	{TRAP,FORK,HANGING_PIECE}	OPENING	B23	Sicilian Defense: Closed	0	0	t	58f4b00d-fd1c-425d-9621-b6402a9aaa05	24	2026-02-28 12:13:16.244	2026-02-28 12:13:16.244	b3d5	r3kbnr/pp1b2pp/1q3p2/4n3/3pP3/1Q1P1N2/PP1BN1PP/2R1KB1R w Kkq - 2 13
qtLqZ	r3k2r/pp1b1ppp/4p3/4P3/1QP2PPq/1PN1p3/P3K1BP/R6R b kq - 2 19	{h4f2,e2d3,f2d2,d3e4,d7c6,c3d5,e6d5}	1519	350	0.06	0	0	{TRAP,FORK,SKEWER,QUEEN_SACRIFICE}	MIDDLEGAME	C00	French Defense: Steinitz Attack	0	0	t	ad8bfb05-2345-49bc-958c-25d7871f99ab	36	2026-02-28 12:13:25.334	2026-02-28 12:13:25.334	f1e2	r3k2r/pp1b1ppp/4p3/4P3/1QP2PPq/1PN1p3/P5BP/R4K1R w kq - 1 19
0jIJ1	r1b5/1p4pk/p6p/2q1Rp1Q/5P2/P2B1nP1/1P4P1/1R3K2 b - - 5 33	{c5g1,f1e2,g1g2,e2e3,f3e5}	2078	350	0.06	0	0	{TRAP,SKEWER,QUEEN_SACRIFICE}	MIDDLEGAME	E20	Nimzo-Indian Defense #2	0	0	t	7afcf866-b227-4952-88f8-76cd4503d863	64	2026-02-28 12:14:56.961	2026-02-28 12:14:56.961	g1f1	r1b5/1p4pk/p6p/2q1Rp1Q/5P2/P2B1nP1/1P4P1/1R4K1 w - - 4 33
CmY9I	N2q2k1/3n2p1/p3p1b1/1pb4p/5rP1/1B5P/PPP2P2/R2QR1K1 b - - 0 21	{d8h4,b3e6,g8h8}	1777	350	0.06	0	0	{HANGING_PIECE}	MIDDLEGAME	B40	Sicilian Defense: Marshall Counterattack	0	0	t	14fa6047-d52c-4474-b710-217399cb8618	40	2026-02-28 12:15:11.751	2026-02-28 12:15:11.751	c7a8	r2q2k1/2Nn2p1/p3p1b1/1pb4p/5rP1/1B5P/PPP2P2/R2QR1K1 w - - 0 21
NMZJ1	2r2rk1/6pp/1Q2p3/2ppP3/7q/2P1R3/PP3PPP/RN4K1 b - - 0 20	{h4f2,g1h1,f2f1}	1556	350	0.06	0	0	{FORK,QUEEN_SACRIFICE,MATE_IN_2,DEFLECTION,BACK_RANK,TRAP}	MIDDLEGAME	B20	Sicilian Defense: Bowdler Attack	0	0	t	5cf8c091-9a4a-41a6-a9f7-1fdcbd67cf26	38	2026-02-28 12:16:19.427	2026-02-28 12:16:19.427	e1e3	2r2rk1/6pp/1Q2p3/2ppP3/7q/2P1n3/PP3PPP/RN2R1K1 w - - 3 20
RSrP9	r2qk1nr/ppp2ppp/2n1b3/2bp4/5P2/PP2P3/1BPP3P/RN1QKBNR b KQkq - 0 7	{d8h4,e1e2,e6g4}	1371	350	0.06	0	0	{HANGING_PIECE}	OPENING	A00	Van't Kruijs Opening	0	0	t	bf4c4df6-c123-4495-adb2-8d7fda30313b	12	2026-02-28 12:16:33.968	2026-02-28 12:16:33.968	g3f4	r2qk1nr/ppp2ppp/2n1b3/2bp4/5p2/PP2P1P1/1BPP3P/RN1QKBNR w KQkq - 0 7
P9GV8	r1b1k2r/pp3pbp/4p1p1/8/8/4BP2/qPP1Q1PP/2KR3R w kq - 0 14	{e2b5,c8d7,b5d7}	1502	350	0.06	0	0	{HANGING_PIECE}	OPENING	B34	Sicilian Defense: Accelerated Dragon, Modern Variation	0	0	t	59f4bf4e-7e0b-4e8a-bdb2-a73d5148ddbc	25	2026-02-28 12:18:26.312	2026-02-28 12:18:26.312	d5a2	r1b1k2r/pp3pbp/4p1p1/3q4/8/4BP2/PPP1Q1PP/2KR3R b kq - 0 13
A0fq2	3rk2r/pp1b3p/6p1/4b1Q1/2q1N3/8/1PP2PP1/R1B2R1K w k - 0 22	{g5e5,d7e6,e5h8}	1662	350	0.06	0	0	{TRAP,FORK,DEFLECTION,HANGING_PIECE}	MIDDLEGAME	C40	Latvian Gambit Accepted	0	0	t	0e3fbeff-0145-4769-ae76-6fed22731f67	41	2026-02-28 12:18:33.291	2026-02-28 12:18:33.291	c7c4	3rk2r/ppqb3p/6p1/4b1Q1/2P1N3/8/1PP2PP1/R1B2R1K b k - 0 21
EyJzo	r5k1/pppn1ppp/2r2q2/8/5N2/1P3Q2/P1PPRPPP/R5K1 b - - 3 16	{f6a1,e2e1,a1e1}	1369	350	0.06	0	0	{MATE_IN_2,DEFLECTION,BACK_RANK,HANGING_PIECE}	MIDDLEGAME	B01	Scandinavian Defense: Modern Variation #2	0	0	t	57ff4a5a-39fe-477e-8617-1f120f6c31c3	30	2026-02-28 12:18:42.647	2026-02-28 12:18:42.647	e1e2	r5k1/pppn1ppp/2r2q2/8/5N2/1P3Q2/P1PP1PPP/R3R1K1 w - - 2 16
NraW4	rnbqk2r/ppp2ppp/4p3/3p4/1b1Pn3/2N2N1P/PPPBPPP1/R2QKB1R w KQkq - 4 6	{c3e4,d5e4,d2b4}	1647	350	0.06	0	0	{DISCOVERED_ATTACK}	OPENING	D01	Queen's Pawn Game: Chigorin Variation	0	0	t	6429a9fd-776b-4979-9901-75c876bdda4c	9	2026-02-28 12:19:39.341	2026-02-28 12:19:39.341	f6e4	rnbqk2r/ppp2ppp/4pn2/3p4/1b1P4/2N2N1P/PPPBPPP1/R2QKB1R b KQkq - 3 5
e4Bjf	r1bq1rk1/ppp2ppp/2n1p3/3pN3/3Pn3/P1B2P1P/1PP1P1P1/R2QKB1R b KQ - 0 9	{d8h4,g2g3,h4g3}	1427	350	0.06	0	0	{MATE_IN_2,TRAP,BACK_RANK}	OPENING	D01	Queen's Pawn Game: Chigorin Variation	0	0	t	6429a9fd-776b-4979-9901-75c876bdda4c	16	2026-02-28 12:19:39.341	2026-02-28 12:19:39.341	f2f3	r1bq1rk1/ppp2ppp/2n1p3/3pN3/3Pn3/P1B4P/1PP1PPP1/R2QKB1R w KQ - 3 9
lz2Z4	r1b1kr2/ppq2p1p/1p3Q2/1P1pp3/3nP3/P1NP1P2/2P3PP/2KR1BNR b q - 0 14	{c7c3,f6e5,c8e6,e5d4,c3d4}	1379	350	0.06	0	0	{PIN,HANGING_PIECE}	OPENING	B02	Alekhine Defense	0	0	t	dc3e6f08-d9a4-4d26-b36a-4b836db6d7d8	26	2026-02-28 12:22:12.914	2026-02-28 12:22:12.914	g7f6	r1b1kr2/ppq2pQp/1p3n2/1P1pp3/3nP3/P1NP1P2/2P3PP/2KR1BNR w q - 1 14
qPWc9	8/p1p2pk1/1p1q2p1/rPn5/4R3/6PP/5P2/2Q1R1K1 b - - 2 33	{c5e4,e1e4,a5b5}	1411	350	0.06	0	0	{DECOY}	MIDDLEGAME	C41	Philidor Defense #2	0	0	t	4d258286-b5a9-449d-9ee5-3fed63b1e682	64	2026-02-28 12:22:55.373	2026-02-28 12:22:55.373	g5c1	8/p1p2pk1/1p1q2p1/rPn3Q1/4R3/6PP/5P2/4R1K1 w - - 1 33
gT34y	5rk1/pp6/2p5/3pq1p1/4p1Pp/P1P1P1rP/1P1R1PK1/3Q1R2 w - - 9 35	{f2g3,e5g3,g2h1}	1839	350	0.06	0	0	{DECOY}	MIDDLEGAME	D02	Queen's Pawn Game: Chigorin Variation	0	0	t	1e278a6f-daff-4b0a-9e72-3c2583401da7	67	2026-02-28 12:23:10.815	2026-02-28 12:23:10.815	f3g3	5rk1/pp6/2p5/3pq1p1/4p1Pp/P1P1Pr1P/1P1R1PK1/3Q1R2 b - - 8 34
ulEWX	2q1nrk1/5ppp/3pb3/1p1Np1PP/2n1P3/P4N2/1P2Q3/1K3B1R w - - 1 23	{d5e7,g8h8,e7c8}	1945	350	0.06	0	0	{TRAP,FORK}	MIDDLEGAME	A43	Old Benoni Defense	0	0	t	b80c9220-beed-4f36-b29b-46f8c85831c6	43	2026-02-28 12:23:45.685	2026-02-28 12:23:45.685	a5c4	2q1nrk1/5ppp/3pb3/np1Np1PP/4P3/P4N2/1P2Q3/1K3B1R b - - 0 22
30SJa	r4rk1/ppp2ppp/3b4/3Pp3/4R3/2PP1Bqb/PP2Q3/R1B2N1K b - - 3 18	{h3f1,e2f1,f7f5}	2049	350	0.06	0	0	{SKEWER,DECOY}	MIDDLEGAME	A04	Zukertort Opening: Black Mustang Defense	0	0	t	b212ac28-05e3-4c15-acd2-6c26c8f80a28	34	2026-02-28 12:26:22.46	2026-02-28 12:26:22.46	d2f1	r4rk1/ppp2ppp/3b4/3Pp3/4R3/2PP1Bqb/PP1NQ3/R1B4K w - - 2 18
Utl36	4R3/6pk/N6p/8/6P1/2PP4/PPr1r1PP/5RK1 b - - 4 36	{e2g2,g1h1,g2h2}	1482	350	0.06	0	0	{BACK_RANK}	MIDDLEGAME	B01	Scandinavian Defense	0	0	t	fca149f0-baab-416e-809a-2446f79b458d	70	2026-02-28 12:27:01.254	2026-02-28 12:27:01.254	b8e8	1R6/6pk/N6p/8/6P1/2PP4/PPr1r1PP/5RK1 w - - 3 36
Nd0ii	r3k2r/Bpp2ppp/p1np1q2/4p3/PPB1P1b1/2PP1N2/5P2/RN1Q1RK1 b kq - 0 13	{g4f3,d1f3,f6f3}	1581	350	0.06	0	0	{DECOY}	OPENING	C50	Italian Game: Giuoco Pianissimo, Normal	0	0	t	30c4c6c9-6f5c-449c-9d68-e7551d484c5f	24	2026-02-28 12:28:45.166	2026-02-28 12:28:45.166	e3a7	r3k2r/bpp2ppp/p1np1q2/4p3/PPB1P1b1/2PPBN2/5P2/RN1Q1RK1 w kq - 2 13
yIa3F	r3r1k1/3b1ppp/1ppp1q2/8/2B1P1n1/2N2P2/PP2Q1PP/R4RK1 b - - 0 18	{f6d4,g1h1,g4e3}	1779	350	0.06	0	0	{TRAP,FORK,BACK_RANK}	MIDDLEGAME	C53	Italian Game: Classical Variation, La Bourdonnais Variation	0	0	t	dfa67699-ec3a-42e4-85ed-3f8590bc8185	34	2026-02-28 12:30:03.767	2026-02-28 12:30:03.767	f2f3	r3r1k1/3b1ppp/1ppp1q2/8/2B1P1n1/2N5/PP2QPPP/R4RK1 w - - 0 18
LOLBu	4r2k/pp3ppp/2p2b2/8/P2p4/6QP/1PP2PP1/1N1Rq1K1 w - - 4 21	{d1e1,e8e1,g1h2}	1327	350	0.06	0	0	{HANGING_PIECE}	MIDDLEGAME	C22	Center Game: Normal Variation	0	0	t	cb7da421-7fe7-41e5-a40d-a87bf2b85f26	39	2026-02-28 12:31:57.202	2026-02-28 12:31:57.202	e6e1	4r2k/pp3ppp/2p1qb2/8/P2p4/6QP/1PP2PP1/1N1R2K1 b - - 3 20
7G8SN	4r3/2pk4/2ppn1p1/1p2bqp1/8/2P1R1PQ/PP3P1P/3R2K1 w - - 3 23	{h3f5,g6f5,e3e5}	1504	350	0.06	0	0	{PIN,TRAP,QUEEN_SACRIFICE,DECOY}	MIDDLEGAME	C55	Italian Game: Anti-Fried Liver Defense	0	0	t	0418ff97-9611-462d-8fef-43936f283ad9	43	2026-02-28 12:33:40.014	2026-02-28 12:33:40.014	f7f5	4r3/2pk1q2/2ppn1p1/1p2b1p1/8/2P1R1PQ/PP3P1P/3R2K1 b - - 2 22
VJ2bE	8/8/2R3pk/P6p/5K2/1P3R1P/2Prr3/8 b - - 0 45	{d2d4,f4g3,h5h4}	1789	350	0.06	0	0	{MATE_IN_2,ROOK_ENDGAME}	ENDGAME	C60	Ruy Lopez	0	0	t	7d5917c1-b721-4edf-8667-30bc46c0b5e7	88	2026-02-28 12:36:39.424	2026-02-28 12:36:39.424	a4a5	8/8/2R3pk/7p/P4K2/1P3R1P/2Prr3/8 w - - 2 45
sHAE9	6k1/n4pp1/1B5p/pP3P2/P2p2P1/R6P/2r1r3/5RK1 b - - 0 37	{e2g2,g1h1,g2h2}	1417	350	0.06	0	0	{BACK_RANK}	MIDDLEGAME	A00	Gedult's Opening	0	0	t	847a311e-1a14-44dc-9c1a-9635dd093726	72	2026-02-28 12:40:42.379	2026-02-28 12:40:42.379	c7b6	6k1/n1B2pp1/1p5p/pP3P2/P2p2P1/R6P/2r1r3/5RK1 w - - 2 37
QlGuu	1r6/2qbkp2/p1pb1p2/3P3r/N3P3/2Q3Pp/PP5P/2R2RK1 w - - 1 24	{c3f6,e7e8,f6f7}	1517	350	0.06	0	0	{TRAP,FORK,QUEEN_SACRIFICE}	MIDDLEGAME	D00	Queen's Pawn Game #2	0	0	t	688ed5fa-fc54-4bb4-8098-955a9f53bd88	45	2026-02-28 12:42:09.331	2026-02-28 12:42:09.331	e8e7	1r2k3/2qb1p2/p1pb1p2/3P3r/N3P3/2Q3Pp/PP5P/2R2RK1 b - - 0 23
idHWE	8/1p6/kb6/7Q/6p1/6P1/r1r4P/1R5K w - - 4 53	{h5b5,a6a7,b5b6}	1801	350	0.06	0	0	{TRAP,FORK,QUEEN_SACRIFICE}	ENDGAME	A03	Bird Opening: Dutch Variation	0	0	t	c01dbb34-dd4a-4e89-84c0-b86c9d262ebe	103	2026-02-28 12:42:34.63	2026-02-28 12:42:34.63	e2c2	8/1p6/kb6/7Q/6p1/6P1/r3r2P/1R5K b - - 3 52
C0B2o	6r1/pp1k3p/6r1/3N4/3p4/4b3/PP5P/R3BR1K b - - 1 30	{g6g1,f1g1,g8g1}	1736	350	0.06	0	0	{FORK,SKEWER,MATE_IN_2,BACK_RANK,TRAP,INTERFERENCE,DECOY}	MIDDLEGAME	B20	Sicilian Defense	0	0	t	ad1e3ee0-fae4-447c-aecb-05d905b30810	58	2026-02-28 12:45:12.748	2026-02-28 12:45:12.748	c3e1	6r1/pp1k3p/6r1/3N4/3p4/2B1b3/PP5P/R4R1K w - - 0 30
jc0Mg	4r2k/p1p3pp/2Q3br/8/4N3/2P1R1Pq/PP3P1P/4R1K1 b - - 0 20	{h3h2,g1f1,h2h3,f1e2,g6h5}	2032	350	0.06	0	0	{TRAP,QUEEN_SACRIFICE,BACK_RANK}	MIDDLEGAME	C63	Ruy Lopez: Schliemann Defense, Exchange Variation	0	0	t	cb6427e3-70ae-4bdb-ad3d-7df9ae5bfda7	38	2026-02-28 12:47:08.723	2026-02-28 12:47:08.723	d2e4	4r2k/p1p3pp/2Q3br/8/4p3/2P1R1Pq/PP1N1P1P/4R1K1 w - - 1 20
h8Y45	2r3k1/3p2pp/2p1pq2/2Q5/2P5/3n2R1/PP4PP/5RK1 b - - 1 24	{f6f1,g1f1,d3c5}	1656	350	0.06	0	0	{TRAP,DEFLECTION,QUEEN_SACRIFICE,BACK_RANK}	MIDDLEGAME	B21	Sicilian Defense: McDonnell Attack	0	0	t	c4fccec2-8f49-4f92-bb8b-e3de5db22cb6	46	2026-02-28 12:47:22.816	2026-02-28 12:47:22.816	e1f1	2r3k1/3p2pp/2p1pq2/2Q5/2P5/3n2R1/PP4PP/4R1K1 w - - 0 24
h2KUX	rnb1kbr1/pp5p/2p5/4p3/2B1PP2/2N4q/PP1P1Q1P/R1B4K b q - 2 17	{f8c5,d2d4,c8g4,c4e2,c5d4}	1385	350	0.06	0	0	{DECOY}	MIDDLEGAME	B01	Scandinavian Defense	0	0	t	de9aea4f-96a7-478d-b5ac-c6cd0ac712ee	32	2026-02-28 12:55:18.238	2026-02-28 12:55:18.238	g1h1	rnb1kbr1/pp5p/2p5/4p3/2B1PP2/2N4q/PP1P1Q1P/R1B3K1 w q - 1 17
ourXx	2N5/8/3p4/pPpPkn1p/8/1P2p3/P3K1PP/8 b - - 0 34	{e5e4,c8d6,f5d6}	2222	350	0.06	0	0	{HANGING_PIECE}	MIDDLEGAME	A01	Nimzo-Larsen Attack: Modern Variation #3	0	0	t	648d14e4-eebf-4a84-ab7b-1f46be7903f9	66	2026-02-28 12:56:43.777	2026-02-28 12:56:43.777	c4b5	2N5/8/3p4/pppPkn1p/2P5/1P2p3/P3K1PP/8 w - - 0 34
KbSsS	8/kp6/p7/q1Q4p/3P4/6P1/2P3KP/8 b - - 3 43	{a5c5,d4c5,a6a5}	1678	350	0.06	0	0	{QUEEN_SACRIFICE}	ENDGAME	C50	Italian Game: Schilling-Kostic Gambit	0	0	t	e39db382-35d2-4114-bd88-d4b22b12cdff	84	2026-02-28 12:57:48.678	2026-02-28 12:57:48.678	f8c5	5Q2/kp6/p7/q6p/3P4/6P1/2P3KP/8 w - - 2 43
jgTOD	4rrk1/4q1p1/p1p3Bp/1pNp3Q/2nB4/2P5/PP4PP/R5K1 b - - 6 25	{e7e1,a1e1,e8e1}	2050	350	0.06	0	0	{FORK,QUEEN_SACRIFICE,MATE_IN_2,BACK_RANK,TRAP,INTERFERENCE,DECOY}	MIDDLEGAME	C82	Ruy Lopez: Open Variations, Dilworth Variation	0	0	t	80ed8255-8935-439f-85ec-a9a314a2418c	48	2026-02-28 12:59:48.934	2026-02-28 12:59:48.934	c2g6	4rrk1/4q1p1/p1p4p/1pNp3Q/2nB4/2P5/PPB3PP/R5K1 w - - 5 25
TM2M3	6k1/1p3p1p/p5p1/4B3/4P3/Pn1r1P2/6PP/2R3K1 w - - 1 29	{c1c8,d3d8,c8d8}	1524	350	0.06	0	0	{MATE_IN_2,BACK_RANK}	MIDDLEGAME	A00	Mieses Opening: Reversed Rat	0	0	t	770cc351-45f6-49aa-b5cf-bfc80ca5bbd2	55	2026-02-28 13:08:31.017	2026-02-28 13:08:31.017	c5b3	6k1/1p3p1p/p5p1/2n1B3/4P3/P2r1P2/6PP/2R3K1 b - - 0 28
m8j3a	r1b5/pp5p/n1pbN1p1/7k/2BP4/2P5/PP3qPP/R1BKR3 w - - 1 20	{c4e2,f2e2,e1e2}	1371	350	0.06	0	0	{TRAP,FORK,DECOY}	MIDDLEGAME	C40	Elephant Gambit	0	0	t	9451a7ea-5d71-41d3-a776-ccb546caf693	37	2026-02-28 13:09:14.598	2026-02-28 13:09:14.598	h6h5	r1b5/pp5p/n1pbN1pk/8/2BP4/2P5/PP3qPP/R1BKR3 b - - 0 19
5H31v	rn1q1rk1/ppp2ppp/6B1/4p3/2PP4/2P1Bb2/P5PP/R2Q1RK1 w - - 0 14	{g6h7,g8h7,f1f3}	1768	350	0.06	0	0	{TRAP}	OPENING	C34	King's Gambit Accepted, King's Knight Gambit	0	0	t	ee70d29d-2790-484f-9562-3d3ac511286f	25	2026-02-28 13:10:36.104	2026-02-28 13:10:36.104	g4f3	rn1q1rk1/ppp2ppp/6B1/4p3/2PP2b1/2P1BN2/P5PP/R2Q1RK1 b - - 0 13
LoKht	5r1k/2p2ppp/q1p5/3nP3/4N2b/1R2BQ1P/2P2RPK/r7 w - - 4 28	{f3f7,a1h1,h2h1}	1787	350	0.06	0	0	{TRAP,QUEEN_SACRIFICE,DECOY}	MIDDLEGAME	C62	Ruy Lopez: Steinitz Defense	0	0	t	d936f9fd-e4f9-496f-9194-671386190639	53	2026-02-28 13:12:17.39	2026-02-28 13:12:17.39	e7h4	5r1k/2p1bppp/q1p5/3nP3/4N3/1R2BQ1P/2P2RPK/r7 b - - 3 27
OZf2K	rnb1kb1r/pppp1ppp/5n2/4P3/1q1Q1P2/8/PPP3PP/RNB1KBNR w KQkq - 1 6	{d4b4,f8b4,c2c3}	1897	350	0.06	0	0	{QUEEN_SACRIFICE}	OPENING	C21	Center Game	0	0	t	05e1c848-91ad-46ae-9a3e-db9493ad6f14	9	2026-02-28 13:13:28.236	2026-02-28 13:13:28.236	e7b4	rnb1kb1r/ppppqppp/5n2/4P3/3Q1P2/8/PPP3PP/RNB1KBNR b KQkq - 0 5
Y1ROu	5r2/p1br2pk/1pP2qpp/8/8/PQ4PP/1P3PB1/R3R1K1 b - - 0 26	{f6f2,g1h1,d7d2}	1829	350	0.06	0	0	{TRAP,FORK,QUEEN_SACRIFICE}	MIDDLEGAME	D02	Queen's Pawn Game: Zukertort Variation	0	0	t	a54499f8-092c-41ce-9b29-ea77fc0327fc	50	2026-02-28 13:16:32.16	2026-02-28 13:16:32.16	c5c6	5r2/p1br2pk/1p3qpp/2P5/8/PQ4PP/1P3PB1/R3R1K1 w - - 1 26
U24TE	1k3bbr/pp4p1/2p2p1p/3n1P2/2NB2P1/1B5P/PPP5/1K2R3 w - - 1 25	{e1e8,b8c7,e8f8}	1834	350	0.06	0	0	{TRAP,FORK}	MIDDLEGAME	B01	Scandinavian Defense: Mieses-Kotroc Variation	0	0	t	858199a5-08f6-4718-8e35-3ea34c6b24cd	47	2026-02-28 13:17:14.64	2026-02-28 13:17:14.64	e7d5	1k3bbr/pp2n1p1/2p2p1p/5P2/2NB2P1/1B5P/PPP5/1K2R3 b - - 0 24
SwYUb	r6r/pp1k1R2/2n1p3/4b1p1/7p/2N4P/PPK3PB/R7 b - - 1 21	{d7e8,h2e5,e8f7}	2081	271.75954762691345	0.059999110145472594	0	1	{HANGING_PIECE}	MIDDLEGAME	B20	Sicilian Defense	0	1	t	00f8af5c-940f-4254-a6f2-27e18a0a257b	40	2026-02-28 12:40:56.655	2026-02-28 15:15:50.272	f1f7	r6r/pp1k4/2n1p3/4b1p1/7p/2N4P/PPK3PB/R4R2 w - - 0 21
LZXVg	4n1k1/6p1/4q1p1/6Np/Q7/P2p1P2/1P4PP/3K4 b - - 1 30	{e6e2,d1c1,d3d2,c1b1,d2d1q,a4d1,e2d1}	1488	299.52702706362174	0.06000284287069452	1	0	{QUEEN_SACRIFICE,PAWN_PROMOTION,BACK_RANK}	MIDDLEGAME	C01	French Defense: Exchange Variation	0	1	t	95c236e5-3d65-4507-9579-d7036f9f3e6f	58	2026-02-28 11:27:11.806	2026-02-28 15:14:01.321	e4g5	4n1k1/6p1/4q1p1/7p/Q3N3/P2p1P2/1P4PP/3K4 w - - 0 30
7fIv2	3rr1k1/p1p2ppp/3b4/4n2q/3Q4/2NP2PP/PPP2P1K/R1B2R2 b - - 4 21	{e5f3,h2g2,f3d4}	1441	266.6801397606955	0.059999417937343084	1	0	{PIN,FORK,TRAP}	MIDDLEGAME	C00	French Defense: Queen's Knight	0	1	t	c13fd9d4-8e09-4440-aebc-e989ee38564e	40	2026-02-28 12:37:56.081	2026-02-28 15:14:22.005	c4d4	3rr1k1/p1p2ppp/3b4/4n2q/2Q5/2NP2PP/PPP2P1K/R1B2R2 w - - 3 21
YOuAt	2r3k1/Nq1nppbp/3p2p1/3P4/4P3/1Q6/PP1B1PPP/2R3K1 b - - 0 22	{c8c1,d2c1,b7a7}	1382	277.9756213701137	0.05999907589966375	1	0	{TRAP,DEFLECTION,BACK_RANK,DECOY}	MIDDLEGAME	B30	Sicilian Defense: Nyezhmetdinov-Rossolimo Attack	1	0	t	c1fcf8ea-0202-4560-8fd3-29ab00fefc3e	42	2026-02-28 11:13:30.762	2026-02-28 15:14:40.489	b5a7	2r3k1/pq1nppbp/3p2p1/1N1P4/4P3/1Q6/PP1B1PPP/2R3K1 w - - 1 22
ewYz2	8/8/8/p3R3/1P5p/P1r2k2/8/5K2 b - - 0 52	{c3c1,e5e1,c1e1}	1507	274.51884882113717	0.059999084745606425	1	0	{BACK_RANK,ROOK_ENDGAME}	ENDGAME	B20	Sicilian Defense: Bowdler Attack	0	0	t	500cb63e-f18f-4776-acd0-c6db605d94b7	102	2026-02-28 11:41:20.415	2026-02-28 15:15:08.215	b3b4	8/8/8/p3R3/7p/PPr2k2/8/5K2 w - - 4 52
\.


--
-- Data for Name: PuzzleAttempt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PuzzleAttempt" (id, "userId", "puzzleId", solved, "hintUsed", "timeSpentSeconds", "ratingBefore", "ratingAfter", "createdAt") FROM stdin;
cmm6go0e0000004juqiodf97l	cmm6gn0rn000004l10v5swj6n	LZXVg	t	f	10	1500	1613	2026-02-28 15:13:32.664
cmm6goxom000604ju97r2uslx	cmm6gn0rn000004l10v5swj6n	7fIv2	t	f	7	1613	1680	2026-02-28 15:14:15.814
cmm6gpfw0000104l1fd7qm0ww	cmm6gn0rn000004l10v5swj6n	YOuAt	t	f	11	1680	1724	2026-02-28 15:14:39.407
cmm6gpr9i000b04judb6iyeyv	cmm6gn0rn000004l10v5swj6n	afw52	t	f	8	1724	1781	2026-02-28 15:14:54.15
cmm6gq1sx000804l1y15kqmwe	cmm6gn0rn000004l10v5swj6n	ewYz2	t	f	7	1781	1829	2026-02-28 15:15:07.809
cmm6gqhhv000b04l1eylmnpfk	cmm6gn0rn000004l10v5swj6n	SwYUb	f	f	14	1829	1777	2026-02-28 15:15:28.147
cmm76j8vv000004jp6s6wg3xy	cmm6gn0rn000004l10v5swj6n	MoI29	t	f	10	1777	1800	2026-03-01 03:17:40.411
\.


--
-- Data for Name: PuzzleCategoryVote; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PuzzleCategoryVote" (id, "userId", "puzzleId", "suggestedTheme", "createdAt") FROM stdin;
\.


--
-- Data for Name: PuzzleFeedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PuzzleFeedback" (id, "userId", "puzzleId", vote, "reportType", "createdAt", "updatedAt") FROM stdin;
cmm6gogit000404juo7ho8x7h	cmm6gn0rn000004l10v5swj6n	LZXVg	f	CATEGORY_WRONG	2026-02-28 15:13:53.573	2026-02-28 15:14:01.117
cmm6gp2av000a04juevqxpido	cmm6gn0rn000004l10v5swj6n	7fIv2	f	\N	2026-02-28 15:14:21.799	2026-02-28 15:14:21.799
cmm6gpgka000404l1boyjfei1	cmm6gn0rn000004l10v5swj6n	YOuAt	t	\N	2026-02-28 15:14:40.282	2026-02-28 15:14:40.282
cmm6gps5i000704l17avg5zrh	cmm6gn0rn000004l10v5swj6n	afw52	f	\N	2026-02-28 15:14:55.302	2026-02-28 15:14:55.302
cmm6gqyev000j04ju56m42awm	cmm6gn0rn000004l10v5swj6n	SwYUb	f	\N	2026-02-28 15:15:50.071	2026-02-28 15:15:50.071
\.


--
-- Data for Name: Session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Session" (id, "sessionToken", "userId", expires) FROM stdin;
\.


--
-- Data for Name: UserCategoryRating; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserCategoryRating" (id, "userId", category, rating, rd, vol, "updatedAt") FROM stdin;
cmm6go10y000204ju9mbkfbp8	cmm6gn0rn000004l10v5swj6n	PAWN_PROMOTION	1613	191.3517543871043	0.06000233429429243	2026-02-28 15:13:33.49
cmm6goy5m000704ju9o3sfcnw	cmm6gn0rn000004l10v5swj6n	PIN	1680	186.8563874300751	0.05999983412458644	2026-02-28 15:14:16.426
cmm6gpgid000304l1tcgyxe9z	cmm6gn0rn000004l10v5swj6n	DEFLECTION	1724	188.3889641630285	0.059999324472806655	2026-02-28 15:14:40.213
cmm6go0v6000104juxp7i52l9	cmm6gn0rn000004l10v5swj6n	QUEEN_SACRIFICE	1781	187.1258105240748	0.05999954408906334	2026-02-28 15:14:54.948
cmm6gpshv000h04ju0lfdqdne	cmm6gn0rn000004l10v5swj6n	INTERFERENCE	1781	187.1258105240748	0.05999954408906334	2026-02-28 15:14:55.747
cmm6gpgtj000604l19ic43d0t	cmm6gn0rn000004l10v5swj6n	DECOY	1781	187.1258105240748	0.05999954408906334	2026-02-28 15:14:55.946
cmm6go16l000304ju6u706gp5	cmm6gn0rn000004l10v5swj6n	BACK_RANK	1829	187.9196251514655	0.059999367488046414	2026-02-28 15:15:08.418
cmm6gq2fg000a04l1vu53qn57	cmm6gn0rn000004l10v5swj6n	ROOK_ENDGAME	1829	187.9196251514655	0.059999367488046414	2026-02-28 15:15:08.62
cmm6gqhyp000c04l1tnlky5ro	cmm6gn0rn000004l10v5swj6n	HANGING_PIECE	1777	187.54531388096913	0.05999942479296136	2026-02-28 15:15:28.752
cmm6gps18000e04juxs5jon2g	cmm6gn0rn000004l10v5swj6n	MATE_IN_2	1800	192.66694511879797	0.059999377999284426	2026-03-01 03:17:41.021
cmm6goyba000804juyt6nuit5	cmm6gn0rn000004l10v5swj6n	FORK	1800	192.66694511879797	0.059999377999284426	2026-03-01 03:17:41.223
cmm6goygx000904jui4vperv0	cmm6gn0rn000004l10v5swj6n	TRAP	1800	192.66694511879797	0.059999377999284426	2026-03-01 03:17:41.422
\.


--
-- Data for Name: VerificationToken; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."VerificationToken" (identifier, token, expires) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-02-28 14:20:47
20211116045059	2026-02-28 14:20:47
20211116050929	2026-02-28 14:20:47
20211116051442	2026-02-28 14:20:47
20211116212300	2026-02-28 14:20:47
20211116213355	2026-02-28 14:20:47
20211116213934	2026-02-28 14:20:47
20211116214523	2026-02-28 14:20:47
20211122062447	2026-02-28 14:20:47
20211124070109	2026-02-28 14:20:47
20211202204204	2026-02-28 14:20:47
20211202204605	2026-02-28 14:20:47
20211210212804	2026-02-28 14:20:47
20211228014915	2026-02-28 14:20:48
20220107221237	2026-02-28 14:20:48
20220228202821	2026-02-28 14:20:48
20220312004840	2026-02-28 14:20:48
20220603231003	2026-02-28 14:20:48
20220603232444	2026-02-28 14:20:48
20220615214548	2026-02-28 14:20:48
20220712093339	2026-02-28 14:20:48
20220908172859	2026-02-28 14:20:48
20220916233421	2026-02-28 14:20:48
20230119133233	2026-02-28 14:20:48
20230128025114	2026-02-28 14:20:48
20230128025212	2026-02-28 14:20:48
20230227211149	2026-02-28 14:20:48
20230228184745	2026-02-28 14:20:48
20230308225145	2026-02-28 14:20:48
20230328144023	2026-02-28 14:20:48
20231018144023	2026-02-28 14:22:56
20231204144023	2026-02-28 14:22:58
20231204144024	2026-02-28 14:22:58
20231204144025	2026-02-28 14:22:58
20240108234812	2026-02-28 14:22:58
20240109165339	2026-02-28 14:22:58
20240227174441	2026-02-28 14:22:58
20240311171622	2026-02-28 14:22:58
20240321100241	2026-02-28 14:22:58
20240401105812	2026-02-28 14:22:59
20240418121054	2026-02-28 14:22:59
20240523004032	2026-02-28 14:22:59
20240618124746	2026-02-28 14:22:59
20240801235015	2026-02-28 14:22:59
20240805133720	2026-02-28 14:22:59
20240827160934	2026-02-28 14:22:59
20240919163303	2026-02-28 14:22:59
20240919163305	2026-02-28 14:22:59
20241019105805	2026-02-28 14:22:59
20241030150047	2026-02-28 14:22:59
20241108114728	2026-02-28 14:22:59
20241121104152	2026-02-28 14:22:59
20241130184212	2026-02-28 14:22:59
20241220035512	2026-02-28 14:22:59
20241220123912	2026-02-28 14:22:59
20241224161212	2026-02-28 14:22:59
20250107150512	2026-02-28 14:22:59
20250110162412	2026-02-28 14:22:59
20250123174212	2026-02-28 14:22:59
20250128220012	2026-02-28 14:22:59
20250506224012	2026-02-28 14:22:59
20250523164012	2026-02-28 14:22:59
20250714121412	2026-02-28 14:22:59
20250905041441	2026-02-28 14:22:59
20251103001201	2026-02-28 14:22:59
20251120212548	2026-02-28 14:22:59
20251120215549	2026-02-28 14:22:59
20260218120000	2026-02-28 14:22:59
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-02-28 14:22:29.939256
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-02-28 14:22:29.969048
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-02-28 14:22:29.972993
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-02-28 14:22:30.000165
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-02-28 14:22:30.067324
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-02-28 14:22:30.071592
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-02-28 14:22:30.077199
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-02-28 14:22:30.082812
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-02-28 14:22:30.08697
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-02-28 14:22:30.091443
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-02-28 14:22:30.095838
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-02-28 14:22:30.100724
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-02-28 14:22:30.105454
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-02-28 14:22:30.109893
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-02-28 14:22:30.114355
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-02-28 14:22:30.141424
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-02-28 14:22:30.146628
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-02-28 14:22:30.150838
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-02-28 14:22:30.155001
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-02-28 14:22:30.161029
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-02-28 14:22:30.165372
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-02-28 14:22:30.170597
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-02-28 14:22:30.182998
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-02-28 14:22:30.192402
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-02-28 14:22:30.197263
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-02-28 14:22:30.201738
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-02-28 14:22:30.206688
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-02-28 14:22:30.210752
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-02-28 14:22:30.214795
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-02-28 14:22:30.218794
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-02-28 14:22:30.222819
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-02-28 14:22:30.227007
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-02-28 14:22:30.231089
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-02-28 14:22:30.235162
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-02-28 14:22:30.239151
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-02-28 14:22:30.243142
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-02-28 14:22:30.2473
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-02-28 14:22:30.251587
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-02-28 14:22:30.256915
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-02-28 14:22:30.267893
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-02-28 14:22:30.271848
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-02-28 14:22:30.275859
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-02-28 14:22:30.279841
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-02-28 14:22:30.283704
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-02-28 14:22:30.287621
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-02-28 14:22:30.292848
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-02-28 14:22:30.303271
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-02-28 14:22:30.308057
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-02-28 14:22:30.312254
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-02-28 14:22:30.328929
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-28 14:22:30.334771
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-28 14:22:30.354944
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-28 14:22:30.357232
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-28 14:22:30.369239
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-28 14:22:30.371909
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-28 14:22:30.373698
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-28 14:22:30.37968
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

\unrestrict XFNuSbDP84iiNBp1AjPM93PyXQ8Tw1RmS6UV4dgNyF2ImSHtl0w4D8VyR3puP8R

