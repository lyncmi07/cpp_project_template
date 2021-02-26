#include <auto_test.hpp>

TEST_SUITE(ExampleSuite)
{
    TEST(0, shouldActuallyCompile)
    {
        ASSERT_EQUALS(true, true);
    }
}
