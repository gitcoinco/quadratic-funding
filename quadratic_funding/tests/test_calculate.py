from unittest import TestCase

import quadratic_funding

class TestCalculate(TestCase):
    def test_is_string(self):
        s = quadratic_funding.calculate()
        self.assertTrue(isinstance(s, str))