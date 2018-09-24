#include "hiker.hpp"
#include "mock_logger.hpp"
#include <gmock/gmock.h>

using namespace ::testing;

namespace {

TEST(Hiker, Life_the_universe_and_everything)
{
    MockLogger logger;
    EXPECT_CALL(logger, log("Hiker::answer()")).Times(Exactly(1));
    Hiker arthur(logger);
    ASSERT_THAT(arthur.answer(), Eq(42));
}

}