using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace SampleWebApplication.Tests
{
    [TestClass]
    public class TestArithmetic
    {
        [TestMethod]
        public void Test_That_Cpu_Can_Add_Properly()
        {
            //setup
            int actual = 5 + 10;
            // invoke some method in SampleWebAppication
            int expected = 15;
            //assert
            Assert.AreEqual(expected, actual);
        }
    }
}
