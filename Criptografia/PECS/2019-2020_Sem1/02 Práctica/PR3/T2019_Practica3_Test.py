#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest

#from T2019_Practica3_Solution_Skeleton import *
from Practica3_Skeleton import *


def numbits(number):
    """ Returns the number of bits needed to represent a given integer """
    return len(bin(number)[2:])


class Test_1_1_KeyGen(unittest.TestCase):

    def test_1(self, bits=32):
        keypair = uoc_rsa_genkeys(bits)
        #print("keypair:", keypair)
        self.assertEqual(numbits(keypair[0][1]), bits)
        self.assertEqual(numbits(keypair[1][1]), bits)

    def test_2(self):
        self.test_1(64)

    def test_3(self):
        self.test_1(128)

    def test_4(self):
        self.test_1(256)

    def test_5(self):
        self.test_1(512)

    def test_6(self):
        self.test_1(1024)


class Test_1_2_Cipher(unittest.TestCase):
    def test_1(self):
        pubkey = [1658920449, 2261011201]
        message = 1324561
        ciphertext = uoc_rsa_cipher(pubkey, message)
        self.assertEqual(ciphertext, 2193168659)

    def test_2(self):
        pubkey = [7390061505324923911, 13622982200639116871]
        message = 1324569837498347741
        ciphertext = uoc_rsa_cipher(pubkey, message)
        self.assertEqual(ciphertext, 10992132361738155226)

    def test_3(self):
        pubkey = [143132818823281027725966978957421094489, 317105356706989254232282864832588327237]
        message = 132456983749834774134322342423423242334
        ciphertext = uoc_rsa_cipher(pubkey, message)
        self.assertEqual(ciphertext, 152965776524476847761981129538647039526)

    def test_4(self):
        pubkey = [4132275859449895754632687451113660725809718872440472927236680630450318334851202188836819213917057636550019634619263924176079749501414584148765340967023181, 8499820230514058278283762682202629912009363093246584356352502850799488827604481674027941570310589727890593958848947560210164054993792107061398220621176737]
        message = 1324569837498347741223476924876401000123876458357120348788992384123874126574652855011234123761289561478561948237569134875634765873465873465834756873465786
        ciphertext = uoc_rsa_cipher(pubkey, message)
        self.assertEqual(ciphertext, 6231467688096520092170561485759944267214126188644258245105836620430943043100978319414343825536989301866239917470896780747649445338622677602263930981220501)



class Test_1_3_Decipher(unittest.TestCase):
    def test_1(self):
        privkey = [2103761841, 2261011201]
        message = 1921192979
        plaintext = uoc_rsa_decipher(privkey, message)
        self.assertEqual(plaintext, 1111111)

    def test_2(self):
        privkey = [10335975308283092767, 13622982200639116871]
        message = 10992132361738155226
        plaintext = uoc_rsa_decipher(privkey, message)
        self.assertEqual(plaintext, 1324569837498347741)

    def test_3(self):
        privkey = [10410680714828286502720886612699273909, 317105356706989254232282864832588327237]
        message = 152965776524476847761981129538647039526
        plaintext = uoc_rsa_decipher(privkey, message)
        self.assertEqual(plaintext, 132456983749834774134322342423423242334)

    def test_4(self):
        privkey = [5894328442430833822632117315552041353536526906709052637159263766789159018186494467492390615653858046702838691141252664123848935504019996229080363765554821, 8499820230514058278283762682202629912009363093246584356352502850799488827604481674027941570310589727890593958848947560210164054993792107061398220621176737]
        message = 6231467688096520092170561485759944267214126188644258245105836620430943043100978319414343825536989301866239917470896780747649445338622677602263930981220501
        plaintext = uoc_rsa_decipher(privkey, message)
        self.assertEqual(plaintext, 1324569837498347741223476924876401000123876458357120348788992384123874126574652855011234123761289561478561948237569134875634765873465873465834756873465786)



class Test_2_1_PollardPm1(unittest.TestCase):
    def test_1(self):
        n = 22610111
        B = 1000
        factor = uoc_pollard_pm1(n, B)
        self.assertTrue(factor != 1)
        self.assertTrue(sympy.gcd(n, factor) == factor)

    def test_2(self):
        n = 62615533
        B = 1000
        factor = uoc_pollard_pm1(n, B)
        self.assertTrue(factor != 1)
        self.assertTrue(sympy.gcd(n, factor) == factor)


    def test_3(self):
        n = 86961699246578969429126180735828978655932602506224317938238947793555213488768317106754867730248121913090377584428944149382014737464370498931360963724550828992337399749525201660573678911706763383401732540259456408467459353816855741089564656335378551166486205600514811470456626503860362203266883487165481026293107
        B = 1000
        factor = uoc_pollard_pm1(n, B)
        self.assertTrue(factor != 1)
        self.assertTrue(sympy.gcd(n, factor) == factor)



class Test_2_2_BreakKey(unittest.TestCase):

    def test_1(self):
        B = 1000
        n = 3085557529
        pubkey = [865718173, n]
        message = 123456
        ciphertext = uoc_rsa_cipher(pubkey, message)

        p = uoc_pollard_pm1(n, B)
        q = n//p

        fake_privkey = uoc_rsa_retrieve_privkey(p, q, pubkey)
        plaintext = uoc_rsa_decipher(fake_privkey, ciphertext)
        self.assertEqual(message, plaintext)

    def test_2(self):
        B = 100
        n = 3010445143
        pubkey = [850559145, n]
        message = 123456
        ciphertext = uoc_rsa_cipher(pubkey, message)

        p = uoc_pollard_pm1(n, B)
        q = n//p

        fake_privkey = uoc_rsa_retrieve_privkey(p, q, pubkey)
        plaintext = uoc_rsa_decipher(fake_privkey, ciphertext)
        self.assertEqual(message, plaintext)


    def test_3(self):

        B = 1000
        n = 86961699246578969429126180735828978655932602506224317938238947793555213488768317106754867730248121913090377584428944149382014737464370498931360963724550828992337399749525201660573678911706763383401732540259456408467459353816855741089564656335378551166486205600514811470456626503860362203266883487165481026293107
        pubkey = [33607853547121798900787114296905650800270921762867271804490008077798998077496007396254006758708133785747845510526813305079327376302493422082491005279948245725305040093090251346215024132677226803477027681385452486905083866346829754239128800474316135901046714907512635238010324885539435360019061171382763786235381, n]
        message = 123456
        ciphertext = uoc_rsa_cipher(pubkey, message)

        p = uoc_pollard_pm1(n, B)
        q = n//p

        fake_privkey = uoc_rsa_retrieve_privkey(p, q, pubkey)
        plaintext = uoc_rsa_decipher(fake_privkey, ciphertext)
        self.assertEqual(message, plaintext)


class Test_3_1_StrongPrimes(unittest.TestCase):
    def test_1(self):
        B = 10
        factor = 1
        keypair = uoc_rsa_genkeys_using_strong_primes(32)
        self.assertEqual(numbits(keypair[0][1]), 32)
        self.assertEqual(numbits(keypair[1][1]), 32)
        self.assertGreater(keypair[0][0], 1)
        self.assertGreater(keypair[0][1], 1)
        self.assertGreater(keypair[1][0], 1)
        self.assertGreater(keypair[1][1], 1)
        factor = uoc_pollard_pm1(keypair[0][1], B)
        self.assertEqual(factor, 1)
        
    def test_2(self):
        B = 100
        factor = 1
        keypair = uoc_rsa_genkeys_using_strong_primes(64)
        self.assertEqual(numbits(keypair[0][1]), 64)
        self.assertEqual(numbits(keypair[1][1]), 64)
        self.assertGreater(keypair[0][0], 1)
        self.assertGreater(keypair[0][1], 1)
        self.assertGreater(keypair[1][0], 1)
        self.assertGreater(keypair[1][1], 1)
        factor = uoc_pollard_pm1(keypair[0][1], B)
        self.assertEqual(factor, 1)
 



if __name__ == '__main__':

    # create a suite with all tests
    test_classes_to_run = [Test_1_1_KeyGen, Test_1_2_Cipher, Test_1_3_Decipher, Test_2_1_PollardPm1, Test_2_2_BreakKey, Test_3_1_StrongPrimes]
    loader = unittest.TestLoader()
    suites_list = []
    for test_class in test_classes_to_run:
        suite = loader.loadTestsFromTestCase(test_class)
        suites_list.append(suite)

    all_tests_suite = unittest.TestSuite(suites_list)

    # run the test suite with high verbosity
    runner = unittest.TextTestRunner(verbosity=2)
    results = runner.run(all_tests_suite)


