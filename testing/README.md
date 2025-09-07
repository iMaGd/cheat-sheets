# Common Test Types

### Unit Test

-   **What:** Test small pieces of code (functions, methods) in
    isolation. Use mocks/fakes instead of real dependencies.\
-   **Why:** Keeps code simple, prevents bugs, builds confidence, and
    makes future changes safer.\
-   **When/Who:** Written by developers, alongside feature development.

------------------------------------------------------------------------

### Integration Test

-   **What:** Test interaction between modules/services, often using a
    test database.\
-   **Why:** Ensures components work together and catches mismatches
    early.\
-   **When/Who:** After modules are built, by developers or QA.

------------------------------------------------------------------------

### System Test

-   **What:** Test the whole system end-to-end from a real user
    perspective (UI, API, DB, files, etc.).\
-   **Why:** Confirms the system as a whole works correctly.\
-   **When/Who:** After major development, by QA team.

------------------------------------------------------------------------

### Acceptance Test

-   **What:** Final test to confirm the product meets customer
    expectations. Uses real business scenarios.\
-   **Why:** Validates business value; if this fails, the project
    fails.\
-   **When/Who:** At the end of a sprint/release, by analysts or
    product/QA teams.

------------------------------------------------------------------------

### Other Useful Tests

-   **Performance Test:** Measure speed, resource use, and scaling under
    load.\
-   **Security Test:** Check for vulnerabilities and data leaks.\
-   **Usability Test:** Validate user experience and ease of use.\
-   **Regression Test:** Re-run old tests to ensure nothing breaks after
    changes.
