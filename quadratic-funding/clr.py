# -*- coding: utf-8 -*-
"""Define the Grants CLR calculations configuration.

Copyright (C) 2020 Gitcoin Core

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

"""
import numpy as np



CLR_PERCENTAGE_DISTRIBUTED = 0
GRANT_CONTRIBUTIONS_EXAMPLE = [
    {
        'id': '4',
        'contributions': [
            { '1': 10.0 },
            { '2': 5.0 },
            { '2': 10.0 },
            { '3': 7.0 },
            { '5': 5.0 },
            { '4': 10.0 },
            { '5': 5.0 },
            { '5': 5.0 }
        ]
    },
    {
        'id': '5',
        'contributions': [
            { '1': 10.0 },
            { '1': 5.0 },
            { '2': 20.0 },
            { '3': 3.0 },
            { '8': 2.0 },
            { '9': 10.0 },
            { '7': 7.0 },
            { '2': 5.0 }
        ]
    }
]



'''
    translates django grant data structure to a list of lists

    args:
        django grant data structure
            {
                'id': (string) ,
                'contibutions' : [
                    {
                        contributor_profile (str) : summed_contributions
                    }
                ]
            }

    returns:
        list of lists of grant data
            [[grant_id (str), user_id (str), contribution_amount (float)]]
'''
def translate_data(grants_data):
    grants_list = []
    for g in grants_data:
        grant_id = g.get('id')
        for c in g.get('contributions'):
            val = [grant_id] + [list(c.keys())[0], list(c.values())[0]]
            grants_list.append(val)

    return grants_list



'''
    aggregates contributions by contributor

    args:
        list of lists of grant data
            [[grant_id (str), user_id (str), contribution_amount (float)]]

    returns:
        aggregated contributions by pair nested dict
            {
                grant_id (str): {
                    user_id (str): aggregated_amount (float)
                }
            }
'''
def aggregate_contributions(grant_contributions):
    contrib_dict = {}
    for proj, user, amount in grant_contributions:
        if proj not in contrib_dict:
            contrib_dict[proj] = {}
        contrib_dict[proj][user] = contrib_dict[proj].get(user, 0) + amount

    return contrib_dict



'''
    gets pair totals between pairs, between current round, across all grants

    args:
        aggregated contributions by pair nested dict
            {
                grant_id (str): {
                    user_id (str): aggregated_amount (float)
                }
            }

    returns:
        pair totals between current round
            {user_id (str): {user_id (str): pair_total (float)}}

'''
def get_totals_by_pair(contrib_dict):
    tot_overlap = {}

    # start pairwise match
    for _, contribz in contrib_dict.items():
        for k1, v1 in contribz.items():
            if k1 not in tot_overlap:
                tot_overlap[k1] = {}

            # pairwise matches to current round
            for k2, v2 in contribz.items():
                if k2 not in tot_overlap[k1]:
                    tot_overlap[k1][k2] = 0
                tot_overlap[k1][k2] += (v1 * v2) ** 0.5

    return tot_overlap



'''
    calculates the clr amount at the given threshold and total pot
    args:
        aggregated contributions by pair nested dict
            {
                grant_id (str): {
                    user_id (str): aggregated_amount (float)
                }
            }
        pair_totals
            {user_id (str): {user_id (str): pair_total (float)}}
        threshold
            float
        total_pot
            float

    returns:
        total clr award by grant, analytics, possibly normalized by the normalization factor
            [{'id': proj, 'number_contributions': _num, 'contribution_amount': _sum, 'clr_amount': tot}]
'''
def calculate_clr(aggregated_contributions, pair_totals, threshold, total_pot):

    bigtot = 0
    totals = []

    for proj, contribz in aggregated_contributions.items():
        tot = 0
        _num = 0
        _sum = 0

        # pairwise match
        for k1, v1 in contribz.items():
            _num += 1
            _sum += v1
            for k2, v2 in contribz.items():
                if k2 > k1:
                    # quadratic formula
                    tot += ((v1 * v2) ** 0.5) / (pair_totals[k1][k2] / (threshold + 1))

        if type(tot) == complex:
            tot = float(tot.real)

        bigtot += tot
        totals.append({'id': proj, 'number_contributions': _num, 'contribution_amount': _sum, 'clr_amount': tot})

    global CLR_PERCENTAGE_DISTRIBUTED

    # if we reach saturation, we need to normalize
    if bigtot >= total_pot:
        CLR_PERCENTAGE_DISTRIBUTED = 100
        for t in totals:
            t['clr_amount'] = ((t['clr_amount'] / bigtot) * total_pot)

    return totals



'''
    clubbed function that runs all calculation functions

    args:
        grant_contribs_curr
            {
                'id': (string) ,
                'contibutions' : [
                    {
                        contributor_profile (str) : contribution_amount (int)
                    }
                ]
            }
        threshold   :   float
        total_pot   :   float

    returns:
        grants clr award amounts
'''
def run_clr_calcs(grant_contribs_curr, threshold, total_pot):

    # get data
    contrib_data = translate_data(grant_contribs_curr)

    # aggregate data
    agg = aggregate_contributions(contrib_data)

    # get pair totals
    ptots = get_totals_by_pair(agg)

    # clr calcluation
    totals = calculate_clr(agg, ptots, threshold, total_pot)

    return totals



if __name__ == '__main__':
    res = run_clr_calcs(GRANT_CONTRIBUTIONS_EXAMPLE, 25.0, 5000)
    print(res)
