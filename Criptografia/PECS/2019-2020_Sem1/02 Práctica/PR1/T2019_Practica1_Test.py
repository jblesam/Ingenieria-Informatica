#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest

#from T2019_Practica1_Solution_Skeleton import *
from T2019_Practica1_Skeleton import *


EXP_KEY_1 = (
        [
            ['A', 'B', 'C', 'D', 'E', 'F'], 
            ['G', 'H', 'I', 'J', 'K', 'L'], 
            ['M', 'N', 'O', 'P', 'Q', 'R'], 
            ['S', 'T', 'U', 'V', 'W', 'X'], 
            ['Y', 'Z', '0', '1', '2', '3'], 
            ['4', '5', '6', '7', '8', '9']
        ], [
            ['W', 'O', 'R', 'L', 'D', '3'], 
            ['A', 'B', 'C', 'E', 'F', 'G'], 
            ['H', 'I', 'J', 'K', 'M', 'N'], 
            ['P', 'Q', 'S', 'T', 'U', 'V'], 
            ['X', 'Y', 'Z', '0', '1', '2'], 
            ['4', '5', '6', '7', '8', '9']
        ], [
            ['H', 'E', 'L', 'O', '5', 'A'], 
            ['B', 'C', 'D', 'F', 'G', 'I'], 
            ['J', 'K', 'M', 'N', 'P', 'Q'], 
            ['R', 'S', 'T', 'U', 'V', 'W'], 
            ['X', 'Y', 'Z', '0', '1', '2'], 
            ['3', '4', '6', '7', '8', '9']
        ], [
            ['A', 'B', 'C', 'D', 'E', 'F'], 
            ['G', 'H', 'I', 'J', 'K', 'L'], 
            ['M', 'N', 'O', 'P', 'Q', 'R'], 
            ['S', 'T', 'U', 'V', 'W', 'X'], 
            ['Y', 'Z', '0', '1', '2', '3'], 
            ['4', '5', '6', '7', '8', '9']
        ])


EXP_KEY_2 = (
        [
            ['A', 'B', 'C', 'D', 'E', 'F'], 
            ['G', 'H', 'I', 'J', 'K', 'L'], 
            ['M', 'N', 'O', 'P', 'Q', 'R'], 
            ['S', 'T', 'U', 'V', 'W', 'X'], 
            ['Y', 'Z', '0', '1', '2', '3'], 
            ['4', '5', '6', '7', '8', '9']
        ], [
            ['C', 'A', 'R', 'D', 'N', 'O'], 
            ['7', 'B', 'E', 'F', 'G', 'H'], 
            ['I', 'J', 'K', 'L', 'M', 'P'], 
            ['Q', 'S', 'T', 'U', 'V', 'W'], 
            ['X', 'Y', 'Z', '0', '1', '2'], 
            ['3', '4', '5', '6', '8', '9']
        ], [
            ['G', 'E', 'R', 'O', 'L', 'A'], 
            ['M', '8', 'B', 'C', 'D', 'F'], 
            ['H', 'I', 'J', 'K', 'N', 'P'], 
            ['Q', 'S', 'T', 'U', 'V', 'W'], 
            ['X', 'Y', 'Z', '0', '1', '2'], 
            ['3', '4', '5', '6', '7', '9']
        ], [
            ['A', 'B', 'C', 'D', 'E', 'F'], 
            ['G', 'H', 'I', 'J', 'K', 'L'], 
            ['M', 'N', 'O', 'P', 'Q', 'R'], 
            ['S', 'T', 'U', 'V', 'W', 'X'], 
            ['Y', 'Z', '0', '1', '2', '3'], 
            ['4', '5', '6', '7', '8', '9']
        ])

EXP_KEY_3 = (
        [
            ['A', 'B', 'C', 'D', 'E', 'F'], 
            ['G', 'H', 'I', 'J', 'K', 'L'], 
            ['M', 'N', 'O', 'P', 'Q', 'R'], 
            ['S', 'T', 'U', 'V', 'W', 'X'], 
            ['Y', 'Z', '0', '1', '2', '3'], 
            ['4', '5', '6', '7', '8', '9']
        ], [
            ['D', 'E', 'L', 'A', 'S', 'T'], 
            ['1', '9', '0', '2', 'B', 'C'], 
            ['F', 'G', 'H', 'I', 'J', 'K'], 
            ['M', 'N', 'O', 'P', 'Q', 'R'], 
            ['U', 'V', 'W', 'X', 'Y', 'Z'], 
            ['3', '4', '5', '6', '7', '8']
        ], [
            ['F', 'E', 'L', 'I', 'X', 'M'], 
            ['A', 'R', '1', '8', '4', '0'], 
            ['B', 'C', 'D', 'G', 'H', 'J'], 
            ['K', 'N', 'O', 'P', 'Q', 'S'], 
            ['T', 'U', 'V', 'W', 'Y', 'Z'], 
            ['2', '3', '5', '6', '7', '9']
        ], [
            ['A', 'B', 'C', 'D', 'E', 'F'], 
            ['G', 'H', 'I', 'J', 'K', 'L'], 
            ['M', 'N', 'O', 'P', 'Q', 'R'], 
            ['S', 'T', 'U', 'V', 'W', 'X'], 
            ['Y', 'Z', '0', '1', '2', '3'], 
            ['4', '5', '6', '7', '8', '9']
        ])







class Test_1_1_KeyGen(unittest.TestCase):
    def test_1(self):
        key = uoc_foursquare_genkey("HELLO5", "WORLD3")
        self.assertEqual(key, EXP_KEY_1)

    def test_2(self):
        key = uoc_foursquare_genkey("GEROLAMO8", "CARDANO7")
        self.assertEqual(key, EXP_KEY_2)

    def test_3(self):
        key = uoc_foursquare_genkey("FELIXMARIE1840", "DELASTELLE1902")
        self.assertEqual(key, EXP_KEY_3)



class Test_1_2_Cipher(unittest.TestCase):
    def test_1(self):
        ciphertext = uoc_foursquare_cipher("CRYPTOGRAPHY", EXP_KEY_1)
        self.assertEqual(ciphertext, "AJ0HTIIHOHBY")

    def test_2(self):
        ciphertext = uoc_foursquare_cipher("CRYPTOGRAPHY", EXP_KEY_2)
        self.assertEqual(ciphertext, "AK0ITJFIOIMY")

    def test_3(self):
        key = uoc_foursquare_genkey("FELIXMARIE1840", "DELASTELLE1902")
        ciphertext = uoc_foursquare_cipher("CRYPTOGRAPHY1", key)
        self.assertEqual(ciphertext, "MHWFOG0FIFAVZP")


class Test_1_3_Decipher(unittest.TestCase):
    def test_1(self):
        plaintext = uoc_foursquare_decipher("AJ0HTIIHOHBY", EXP_KEY_1)
        self.assertEqual(plaintext, "CRYPTOGRAPHY")

    def test_2(self):
        plaintext = uoc_foursquare_decipher("AK0ITJFIOIMY", EXP_KEY_2)
        self.assertEqual(plaintext, "CRYPTOGRAPHY")

    def test_3(self):
        key = uoc_foursquare_genkey("FELIXMARIE1840", "DELASTELLE1902")
        plaintext = uoc_foursquare_decipher("MHWFOG0FIFAVZP", key)
        self.assertEqual(plaintext, "CRYPTOGRAPHY1")





if __name__ == '__main__':

    # create a suite with all tests
    test_classes_to_run = [Test_1_1_KeyGen, Test_1_2_Cipher, Test_1_3_Decipher]
    loader = unittest.TestLoader()
    suites_list = []
    for test_class in test_classes_to_run:
        suite = loader.loadTestsFromTestCase(test_class)
        suites_list.append(suite)

    all_tests_suite = unittest.TestSuite(suites_list)

    # run the test suite with high verbosity
    runner = unittest.TextTestRunner(verbosity=2)
    results = runner.run(all_tests_suite)
