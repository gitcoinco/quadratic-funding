### Quadratic Funding

This is an open source implementation of quadratic funding or liberal radicalism, a design for philanthropic and publicly-funded seeding which allows for optimal provisioning of funds to an ecosystem of public goods. 

This concept was adapted from [a paper](https://poseidon01.ssrn.com/delivery.php?ID=660029082067073116118109064122080113007059056088020045126118025097091089104095118005013117053102018063007119114004031115071017112038078013065115004125088127124090068088040053112098119108124088124100127091000084029019003094031089072104067086002002114101&EXT=pdf) written by Vitalik Buterin, Zoë Hitzig and Glen Weyl of liberal radicalism fame.

### Usage


#### Possible Parameters


| Parameter                                                                         | Allowed Values             | Mandatory | Default    | Status |
|-----------------------------------------------------------------------------------|----------------------------|-----------|------------|--------|
| [positive_contributions](#positive_contributions)                                 | `[<Contributions>]`        | ✓         |            | x      |
| [type](#type)                                                                     | `pairwise` \| `individual` |           | `pairwise` | x      |
| [threshold](#threshold)                                                           | `<Decimal>`                |           | `25.0`     | x      |
| [normalize_on_saturation](#normalize_on_saturation)                               | `True` \| `False`          |           | `False`    | x      |
| [cap_at](#cap_at)                                                                 | `<Decimal>`                |           | `None`     | x      |
| [previous_round_contributions](#previous_round_contributions)                     | `[<Contributions>]`        |           | `None`     | x      |
| [previous_round_contributions_weightage](#previous_round_contributions_weightage) | `<Decimal>`                |           | `0.33`     | x      |
| [negative_contributions](#negative_contributions)                                 | `[<Contributions>]`        |           | `None`     | x      |

###### positive_contributions

 // Description + Format

###### type

 // Description + Format

###### threshold

 // Description + Format

###### normalize_on_saturation

 // Description + Format

###### cap_at

 // Description + Format

###### previous_round_contributions

 // Description + Format

###### previous_round_contributions_weightage

 // Description + Format

###### negative_contributions

 // Description + Format




### How it Works

The idea of a quadratic voting system was the starting point for Gitcoin's funding open source experiment.

The math behind liberal radicalism (LR) can be quite complex, but essentially, individuals make public goods contributions to projects of value to them. The amount received by the project is the amount donated, and an additional amount proportional to the square of the sum of the square roots of contributions received, minus the actual contributions themselves (the sum of the contributions itself, by project.

So basically, you can think of donating to a Gitcoin Grant as two steps:

1. Individuals crowdfund donations towards public goods (for example: commonly used repositories in open source software).

2. These individual contributions are "matched" by funds from a government, grants program, or private philanthropist.

How the match is calculated is essentially liberal radicalism (LR), which can be summarized as "crowdfunding, with a matching function." Gitcoin's first round was a capital constrained version of LR, since the match amount is limited by the pot of funds that we get from philantropists. Capital constrained liberal radicalism is what we call "CLR", which you'll find conveniently used throughout our site.

Why this, and not just 1:1 matching? 

Using LR/CLR in open source ideally helps to prevent the "tragedy of the commons." In open souce, every individual that has an incentive to consume an OSS resource at the expense of every other individual has no way to exclude anyone else from consuming it, resulting in overconsumption, under investment, and ultimately, depletion of the resource.

LR puts an emphasis on the number of donations, rather than the size of the donation itself. This is the intended feature of the LR mechanism. Projects that can get more people to donate to them represent public goods that serve a larger public, so the tragedy of the commons problem is more severe, and hence, contributions to them should be multiplied more to compensate. 

### Problems Observed (Rounds 1 & 2)

Sybil resistance: We know that grants which receive many small contributions result in a larger "top-off" value from the benefactor, incentivizing an attack vector to create multiple dummy accounts to try to confuse the system.

Collusion: An attacker of the system could split up $100 into 10 people's hands, and thus achieve a much higher CLR match than deserved.

Reliance on philanthropists: In practice, CLR still suffers from reliance on a benefactor or government, a part of the problem which it purports to solve. The paper simultaneously shows disappointment in OSS leaning on "proprietary corporate backing or directed, hierarchical government support", while acknowledging CLR still requires a benefactor. Is it possible for free markets dictate more funding towards public goods?

Prior knowledge: One of the drawbacks of this entire experiment is the fact that once the mechanism is known, people will know how to game it.

### Pairwise Mechanism (DRAFT)

BENEFITS OF PAIRWISE
number of donations matters more
lump sum donations get represented less
collusion can still happen, but it's much easier to find

POSSIBLE GRAPH?
num_contributions on the x-axis
high_donation on the y-axis
clr matching funds as size of the bubble

ANALYSIS AID
collusion with pairs is much easier to find (you can use something like time, date, geographical location, github age, by pair)

HOW DID PAIRWISE ALLEVIATE ROUND 1 & 2 PROBLEMS?

### Problems Observed (Round 3-5)

Identity:

Saturation of the round:

Discoverability of new grants:

### Further Development

### Additional Reading

**Foundations**

- [Standard Bounties Contract](https://github.com/Bounties-Network/StandardBounties)
- [EIP-1337](https://github.com/ethereum/EIPs/pull/1337)
- [Gitcoin Grants](https://github.com/gitcoinco/grants1337)

**Research Papers**

- [Liberalism Radicalism: A Flexible Design For Philanthropic Matching Funds](https://poseidon01.ssrn.com/delivery.php?ID=660029082067073116118109064122080113007059056088020045126118025097091089104095118005013117053102018063007119114004031115071017112038078013065115004125088127124090068088040053112098119108124088124100127091000084029019003094031089072104067086002002114101&EXT=pdf)
- [Pairwise Coordination - A New Quadratic Funding Design](https://ethresear.ch/t/pairwise-coordination-subsidies-a-new-quadratic-funding-design/5553/9)
- [Minimal Anti-Collusion Infrastructure](https://ethresear.ch/t/minimal-anti-collusion-infrastructure/5413/2)

**Blog Posts**

- [Gitcoin Grants: Q1 Match + 2020 Roadmap](https://gitcoin.co/blog/gitcoin-grants-2020/)
- [Gitcoin Grants](https://gitcoin.co/blog/gitcoin-grants/)
- [Experiments with Liberal Radicalism](https://gitcoin.co/blog/experiments-with-liberal-radicalism/)
- [Gitcoin Grants: CLR Matching](https://gitcoin.co/blog/gitcoin-grants-clr-matching/)
- [Radical Results: Gitcoin's $25K Match](https://gitcoin.co/blog/radical-results-gitcoins-25k-match/)
- [Gitcoin Grants: $50K Open Source Fund](https://gitcoin.co/blog/gitcoin-grants-50k-open-source-fund/)
- [Gitcoin’s Q3 Match: $100K+ to OSS projects](https://gitcoin.co/blog/gitcoins-q3-match-100k-to-oss-projects/)
- [Gitcoin's Q3 Match The Radical Results](https://gitcoin.co/blog/gitcoins-q3-match/)
- [Gitcoin Grants Round 4 Results](https://gitcoin.co/blog/gitcoin-grants-round-4/)
- [Gitcoin Grants Round 5: Funding Our Future](https://gitcoin.co/blog/gitcoin-grants-round-5-funding-our-future/)
- [Gitcoin Grants Round 6](https://gitcoin.co/blog/gitcoin-grants-round-6/)
- [Vitalik's Blog - Review of Gitcoin Quadratic Funding Round 3](https://vitalik.ca/general/2019/10/24/gitcoin.html)
- [Vitalik's Blog - Review of Gitcoin Quadratic Funding Round 4](https://vitalik.ca/general/2020/01/28/round4.html)
- [Vitalik's Blog - Gitcoin Grants Round 5 Retrospective](https://vitalik.ca/general/2020/04/30/round5.html)


### Licenses

- [Code - GNU AFFERO GENERAL PUBLIC LICENSE](../LICENSE)
- [Creative assets -- Attribution-NonCommercial-NoDerivatives 4.0 International](../app/assets/LICENSE.txt)
